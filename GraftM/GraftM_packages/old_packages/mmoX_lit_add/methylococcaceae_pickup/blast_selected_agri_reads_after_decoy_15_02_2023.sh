#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup
odir=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup/graftm_decoy_15_02_2023
cd $WD

###First I want to extract all the sequences. First I will concatenate all the cds into 1 file that I can grep onto;
for line in $(cat $WD/unique_seqids.txt); do
cat $odir/graftm/"$line"/"$line"_R1_fastp_orf/"$line"_R1_fastp_orf_hits.fa >> $WD/temp1.fa \
echo $line; done

##Then I need to grep from my "cds_to_blast" file
module load SeqKit/2.0.0

seqkit grep -f $WD/cds_to_blast_after_decoy.txt $WD/temp1.fa -o $WD/cds_to_blast_after_decoy.fa
rm $WD/temp1.fa

module purge
module load DIAMOND/2.0.9-foss-2020b

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD/cds_to_blast_after_decoy.fa -f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD/cds_blast_after_decoy_results.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 10

module purge