#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup
odir=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup/selection_shallow_21_12_2022
cd $WD

###First I want to extract all the sequences. First I will concatenate all the cds into 1 file that I can grep onto;
for line in $(cat $WD/unique_seqids.txt); do
cat $odir/"$line"/"$line"_R1_fastp/"$line"_R1_fastp_orf.fa >> $WD/temp1.fa \
echo $line; done

##Then I need to grep from my "cds_to_blast" file
module load SeqKit/2.0.0

seqkit grep -f $WD/cds_to_blast.txt $WD/temp1.fa -o $WD/cds_to_blast.fa
rm $WD/temp1.fa

module purge
module load DIAMOND/2.0.9-foss-2020b

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD/cds_to_blast.fa -f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD/cds_blast_results.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 10

module purge