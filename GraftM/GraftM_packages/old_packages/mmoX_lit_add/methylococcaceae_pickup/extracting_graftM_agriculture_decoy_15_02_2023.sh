#!/bin/bash
WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup
odir=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup/graftm_decoy_15_02_2023
cd $WD

#Noget helt nyt! Først vil jeg gerne sige 
for line in $(cat $WD/unique_seqids.txt); do
  grep -v "#" $odir/graftm/"$line"/"$line"_R1_fastp_orf/"$line"_R1_fastp_orf.hmmout.txt \
  | tr -s ' ' | awk -F' ' -v OFS='\t' "{print \"$line\", \$1, \$16, \$17}" \
>> $WD/hmm_hit_file_decoy.tsv \
  && echo $line
done

sort -k2 $WD/hmm_hit_file_decoy.tsv > $WD/hmm_hit_file_decoy_sorted.tsv

#Then I want to concatenate all the read_tax files
for line in $(cat $WD/unique_seqids.txt); do
  grep -w "Root; likely_mmoX;" $odir/graftm/"$line"/"$line"_R1_fastp_orf/"$line"_R1_fastp_orf_read_tax.tsv \
>> $WD/tax_file_decoy.tsv \
  && echo $line
done

sort -k1 $WD/tax_file_decoy.tsv > $WD/tax_file_decoy_sorted.tsv

### Joining and printing header below. Since I join by the tax file, the high E-value reads should be removed, as they are not reported to the read_tax file ###
(join -t $'\t' -1 1 -2 2 -o '2.1 1.1 1.2 2.3 2.4' $WD/tax_file_decoy_sorted.tsv $WD/hmm_hit_file_decoy_sorted.tsv \
 | awk -v OFS='\t' 'BEGIN{print "Sample\tSequence\tTax\thmm_start\thmm_end"} {print $0}') \
> $WD/position_of_mmoX_hits_decoy.tsv
