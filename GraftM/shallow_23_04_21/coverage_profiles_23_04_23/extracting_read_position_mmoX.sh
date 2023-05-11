#!/bin/bash

WD=/user_data/kalinka/GraftM/shallow_23_04_21/coverage_profiles_23_04_23
graftm_mmoX=/user_data/kalinka/GraftM/shallow_23_04_21/mmoX/graftm
cd $WD
mkdir $WD/Position_files
odir=$WD/Position_files
samples=/user_data/kalinka/GraftM/shallow_23_04_21/searchfile_combined.txt


#First, the HMM output file needs to be sorted and the HMM position needs to be extracted 
for line in $(cat $samples); do
  grep -v "#" $graftm_mmoX/"$line"/"$line"_R1_fastp/"$line"_R1_fastp.hmmout.txt \
  | tr -s ' ' | awk '{ if ($12 < 1e-10) {print $0}}' \
  | awk -F' ' -v OFS='\t' "{print \"$line\", \$1, \$16, \$17}" \
>> $odir/hmm_hit_file_mmoX.tsv ; done

## Then sorting this file based on the read_ID
sort -k2 $odir/hmm_hit_file_mmoX.tsv > $odir/hmm_hit_file_sorted_mmoX.tsv

#Then I want to concatenate all the read_tax files
for line in $(cat $samples); do
cat $graftm_mmoX/"$line"/"$line"_R1_fastp/"$line"_R1_fastp_read_tax.tsv \
| grep -w "Root; Likely_mmoX;" \
>> $odir/tax_file_mmoX.tsv; done

sort -k1 $odir/tax_file_mmoX.tsv > $odir/tax_file_sorted_mmoX.tsv


### Joining and printing header below. Since I join by the tax file, the high E-value reads should be removed, as they are not reported to the read_tax file ###
(join -t $'\t' -1 1 -2 2 -o '2.1 1.1 1.2 2.3 2.4' $odir/tax_file_sorted_mmoX.tsv $odir/hmm_hit_file_sorted_mmoX.tsv \
 | awk -v OFS='\t' 'BEGIN{print "Sample\tSequence\tTax\thmm_start\thmm_end"} {print $0}') \
> $odir/position_of_mmoX_hits.tsv

### Removing all files but the position of hits file ###
rm -r $odir/tax_file_sorted_mmoX.tsv $odir/hmm_hit_file_sorted_mmoX.tsv $odir/tax_file_mmoX.tsv $odir/hmm_hit_file_mmoX.tsv

##### Then, I need to run a script in R to get this to work ###

module load RStudio-Desktop/1.1.456-foss-2018a

Rscript $WD/coverage_profiles_mmoX.R