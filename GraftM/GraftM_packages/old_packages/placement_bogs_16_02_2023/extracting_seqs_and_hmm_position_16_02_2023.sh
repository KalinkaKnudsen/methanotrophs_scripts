#!/bin/bash
WD=/user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023
mkdir -p /user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/shallow_selected_samples/mmoX
mkdir -p /user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/shallow_selected_samples/pmoA


odir_mmoX=/user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/shallow_selected_samples/mmoX
odir_pmoA=/user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/shallow_selected_samples/pmoA
shallow_mmoX=/user_data/kalinka/GraftM/shallow_21_12_2022/mmoX/graftm
shallow_pmoA=/user_data/kalinka/GraftM/shallow_21_12_2022/pmoA/graftm
cd $WD

for line in $(cat $WD/bogs_seqid.txt); do
    cp -R $shallow_mmoX/"$line" $odir_mmoX \
  | echo $line; done

#Extracting the positions
for line in $(cat $WD/bogs_seqid.txt); do
  grep -v "#" $odir_mmoX/"$line"/"$line"_R1_fastp/"$line"_R1_fastp.hmmout.txt \
  | tr -s ' ' | awk -F' ' -v OFS='\t' "{print \"$line\", \$1, \$16, \$17}" \
>> $WD/bog_hit_mmoX.tsv \
  && echo $line
done

sort -k2 $WD/bog_hit_mmoX.tsv > $WD/bog_hit_mmoX_sorted.tsv

#Then I want to concatenate all the read_tax files
for line in $(cat $WD/bogs_seqid.txt); do
  grep -w "Root; likely_mmoX;" $odir_mmoX/"$line"/"$line"_R1_fastp/"$line"_R1_fastp_read_tax.tsv \
>> $WD/bog_tax_file_mmoX.tsv \
  && echo $line
done

sort -k1 $WD/bog_tax_file_mmoX.tsv > $WD/bog_tax_file_mmoX_sorted.tsv

### Joining and printing header below. Since I join by the tax file, the high E-value reads should be removed, as they are not reported to the read_tax file ###
(join -t $'\t' -1 1 -2 2 -o '2.1 1.1 1.2 2.3 2.4' $WD/bog_tax_file_mmoX_sorted.tsv $WD/bog_hit_mmoX_sorted.tsv \
 | awk -v OFS='\t' 'BEGIN{print "Sample\tSequence\tTax\thmm_start\thmm_end"} {print $0}') \
> $WD/bog_position_of_mmoX_hits.tsv



############# pmoA ############


for line in $(cat $WD/bogs_seqid.txt); do
    cp -R $shallow_pmoA/"$line" $odir_pmoA \
  | echo $line; done

#Extracting the positions
for line in $(cat $WD/bogs_seqid.txt); do
  grep -v "#" $odir_pmoA/"$line"/"$line"_R1_fastp/"$line"_R1_fastp.hmmout.txt \
  | tr -s ' ' | awk -F' ' -v OFS='\t' "{print \"$line\", \$1, \$16, \$17}" \
>> $WD/bog_hit_pmoA.tsv \
  && echo $line
done

sort -k2 $WD/bog_hit_pmoA.tsv > $WD/bog_hit_pmoA_sorted.tsv

#Then I want to concatenate all the read_tax files
for line in $(cat $WD/bogs_seqid.txt); do 
  cat $odir_pmoA/"$line"/"$line"_R1_fastp/"$line"_R1_fastp_read_tax.tsv \
| grep -w "Root;"\
| grep -v "Root; Homologous_pmoA" \
| grep -v "Root; Homologous_pmoA; HMO_cluster" \
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira; Nitrospira_clade_B" \
| grep -v "Root; pmoA_amoA_pxmA; amoA; Betaproteobacteria_amoA" \
| grep -v "Root; pmoA_amoA_pxmA; amoA"\
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira; Nitrospira_clade_A" \
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira"\
| grep -v "Root; Homologous_pmoA; Actinobacteria" \
| grep -v "Root; Homologous_pmoA; Deltaproteobacteria_Binataceae_cluster; HMO_group_1"\
| grep -v "Root; pmoA_amoA_pxmA; pmoA; Nitrosococcus"\
| grep -v "Root; pmoA_amoA_pxmA; pmoA; Cycloclasticus"\
| grep -v "Root; pmoA_amoA_pxmA; Probably_hydrocarbon_monooxygenases; Cycloclasticus_bradhyrhizobium_cluster"\
| grep -v "Root; pmoA_amoA_pxmA; Probably_hydrocarbon_monooxygenases" \
>> $WD/bog_tax_file_pmoA.tsv \
  && echo $line
done

sort -k1 $WD/bog_tax_file_pmoA.tsv > $WD/bog_tax_file_pmoA_sorted.tsv

### Joining and printing header below. Since I join by the tax file, the high E-value reads should be removed, as they are not reported to the read_tax file ###
(join -t $'\t' -1 1 -2 2 -o '2.1 1.1 1.2 2.3 2.4' $WD/bog_tax_file_pmoA_sorted.tsv $WD/bog_hit_pmoA_sorted.tsv \
 | awk -v OFS='\t' 'BEGIN{print "Sample\tSequence\tTax\thmm_start\thmm_end"} {print $0}') \
> $WD/bog_position_of_pmoA_hits.tsv



### Investigating the "filtered" portion of the pmoA ###

#So here I am printing the taxfile, and then removing (-v) all the reads from the bog_tax_file_pmoA file. It takes a bit of time
for line in $(cat $WD/bogs_seqid.txt); do 
  cat $odir_pmoA/"$line"/"$line"_R1_fastp/"$line"_R1_fastp_read_tax.tsv \
| grep -vf $WD/bog_tax_file_pmoA.tsv  \
>> $WD/bog_tax_file_pmoA_removed_tax.tsv \
  && echo $line
done

sort -k1 $WD/bog_tax_file_pmoA_removed_tax.tsv > $WD/bog_tax_file_pmoA_removed_tax_sorted.tsv

(join -t $'\t' -1 1 -2 2 -o '2.1 1.1 1.2 2.3 2.4' $WD/bog_tax_file_pmoA_removed_tax_sorted.tsv $WD/bog_hit_pmoA_sorted.tsv \
 | awk -v OFS='\t' 'BEGIN{print "Sample\tSequence\tTax\thmm_start\thmm_end"} {print $0}') \
> $WD/bog_position_of_pmoA_hits_removed.tsv
