#!/bin/bash

WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads
cd $WD
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt
output_path=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift/no_filter

mkdir $output_path/mmoX
mkdir $output_path/pmoA

module purge
module load DIAMOND/2.0.9-foss-2020b
module load parallel

temp=/user_data/kalinka/temp
export TMPDIR=/user_data/kalinka/temp

db_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.dmnd
db_mmoX=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.dmnd
pmoA_seqs=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.fa
mmoX_seqs=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.fa

THREADS=12
#--frameshift/-F 

#Penalty for frameshifts in DNA-vs-protein alignments. Values around 15 are reasonable for this parameter. 
#Enabling this feature will have the aligner tolerate missing bases in DNA sequences and is most recommended for long, error-prone sequences like MinION reads.
#In the pairwise output format, frameshifts will be indicated by \ and / for a shift by +1 and -1 nucleotide in the direction of translation respectively. Note that this feature is disabled by default.
# The "*" character in the qseq_translated field of the output from DIAMOND blastx indicates that a gap was introduced in the translation due to the frameshift-aware alignment option.

cat $searchfile | parallel -j3 --tmpdir $temp diamond blastx --db $db_pmoA --frameshift 15 --verbose --threads $THREADS -b12 \
-c1 --max-target-seqs 1 -f 6 qseqid sseqid sstart send length slen qstart qend qlen qframe evalue bitscore nident pident \
mismatch qseq_translated qseq --query $WD/pmoA/graftm/{}/{}/{}_hits.fa \
-o $output_path/pmoA/{}.txt --tmpdir /user_data/kalinka/temp  '&>' $output_path/pmoA/{}.log


###Then I want to make a filter that works like what I am doing in the HMM. I do not want to filter in the blastx, because I want to be able to trace back!
####But i could probably do in by working with the blast filters/options ####

#I need to filter at columns "length" which is col 5. That is the length of the alignment. I will set that to 240, and then 400 for mmoX

for line in $(cat $searchfile); do
    awk '{ if ($5 > 240) {print $0}}' \
    $output_path/pmoA/"$line".txt \
    > $output_path/pmoA/"$line"_filter240.txt
done


#### Then, I want to extract the sequences after the filtering. That must be col 1 and col 16
for line in $(cat $searchfile); do
    awk '{{print ">"$1 "\n" $16}}' \
    $output_path/pmoA/"$line"_filter240.txt \
    > $output_path/pmoA/"$line"_filter240_sequences.fa
done


##### Or still not filtering to be able to compare directly to the raw reads;
for line in $(cat $searchfile); do
    awk '{{print ">"$1 "\n" $16}}' \
    $output_path/pmoA/"$line".txt \
    > $output_path/pmoA/"$line"_sequences.fa
done