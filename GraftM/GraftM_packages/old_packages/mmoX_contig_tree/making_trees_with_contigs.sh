#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_contig_tree
cd $WD


module load MAFFT/7.490-GCC-10.2.0-with-extensions
###Combining the files

cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/combined_contigs_mmoX_cluster1.fa \
/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.faa \
 > $WD/contig_original_mmoX.fa


mafft $WD/contig_original_mmoX.fa \
 > $WD/contig_original_mmoX_aligned.fa

module load TrimAl/1.4.1-foss-2020b
trimal -in $WD/contig_original_mmoX_aligned.fa \
 -out $WD/contig_original_mmoX_aligned_20perc2.fa -gt 0.2

module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $WD/contig_original_mmoX_aligned_20perc2.fa -m MFP -nt AUTO -B 1000 -T 10
