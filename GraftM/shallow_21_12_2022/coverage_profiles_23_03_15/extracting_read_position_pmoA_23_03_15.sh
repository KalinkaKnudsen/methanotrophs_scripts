#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages/coverage_profiles_23_03_15
graftm_pmoA=/user_data/kalinka/GraftM/shallow_21_12_2022/user_data/kalinka/GraftM/shallow_21_12_2022/pmoA/graftm
cd $WD
odir=$WD/Position_files

ls $graftm_pmoA > $odir/samples.txt

start_time=$(date +%s)

#First, the HMM output file needs to be sorted and the HMM position needs to be extracted 
for line in $(cat $odir/samples.txt); do
  grep -v "#" $graftm_pmoA/"$line"/"$line"_R1_fastp/"$line"_R1_fastp.hmmout.txt \
  | tr -s ' ' | awk -F' ' -v OFS='\t' "{print \"$line\", \$1, \$16, \$17}" \
>> $odir/hmm_hit_file_pmoA.tsv ; done

## Then sorting this file based on the read_ID
sort -k2 $odir/hmm_hit_file_pmoA.tsv > $odir/hmm_hit_file_sorted_pmoA.tsv

hmm_time=$(date +%s)
hmm_elapsed_time=$((hmm_time - start_time))
echo "Elapsed time for extracting HMM: $hmm_elapsed_time seconds" >> $odir/time_pmoA.txt

#Then I want to concatenate all the read_tax files
for line in $(cat $odir/samples.txt); do
cat $graftm_pmoA/"$line"/"$line"_R1_fastp/"$line"_R1_fastp_read_tax.tsv \
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
>> $odir/tax_file_pmoA.tsv; done

sort -k1 $odir/tax_file_pmoA.tsv > $odir/tax_file_sorted_pmoA.tsv


### Joining and printing header below. Since I join by the tax file, the high E-value reads should be removed, as they are not reported to the read_tax file ###
(join -t $'\t' -1 1 -2 2 -o '2.1 1.1 1.2 2.3 2.4' $odir/tax_file_sorted_pmoA.tsv $odir/hmm_hit_file_sorted_pmoA.tsv \
 | awk -v OFS='\t' 'BEGIN{print "Sample\tSequence\tTax\thmm_start\thmm_end"} {print $0}') \
> $odir/position_of_pmoA_hits.tsv

tax_time=$(date +%s)
tax_elapsed_time=$((tax_time - hmm_time))
echo "Elapsed time for extracting tax: $tax_elapsed_time seconds" >> $odir/time_pmoA.txt

### Removing all files but the position of hits file ###
rm -r $odir/tax_file_sorted_pmoA.tsv $odir/hmm_hit_file_sorted_pmoA.tsv $odir/tax_file_pmoA.tsv $odir/hmm_hit_file_pmoA.tsv

##### Then, I need to run a script in R to get this to work ###

module load RStudio-Desktop/1.1.456-foss-2018a

Rscript $WD/coverage_profiles.R
R_time=$(date +%s)
R_elapsed_time=$((R_time - tax_time))
echo "Elapsed time for plotting in R: $R_elapsed_time seconds" >> $odir/time_pmoA.txt

combined_elapsed_time=$((R_time - start_time))
echo "Elapsed time for the entire script: $combined_elapsed_time seconds" >> $odir/time_pmoA.txt
