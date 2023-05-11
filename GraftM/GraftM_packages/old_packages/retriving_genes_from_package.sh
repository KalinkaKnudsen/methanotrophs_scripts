#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages
cd $WD

module purge
module load DIAMOND/2.0.9-foss-2020b

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.faa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD/pmoA_blast_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 10

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.faa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD/mmoX_blast_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 10

module purge