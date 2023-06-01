#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023
cd $WD

cat $WD/chloroflexi_soli_cluster_seqs_cleaned_50.fa >> $WD/combined_mmoX_seqs.fa
cat $WD/actino_soli_cluster_seqs_50.fa >> $WD/combined_mmoX_seqs.fa
cat $WD/mmoX_seqs_add15_02_2023.faa >> $WD/combined_mmoX_seqs.fa
cat /user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.faa >> $WD/combined_mmoX_seqs.fa



#### Creating MSA with MAFT 
module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $WD/combined_mmoX_seqs.fa > $WD/combined_mmoX_seqs_aligned.fa

## Then trimming at 20% representation
module load TrimAl/1.4.1-foss-2020b
trimal -in $WD/combined_mmoX_seqs_aligned.fa -out $WD/combined_mmoX_seqs_aligned_20perc2.fa -gt 0.2

#Runs on axo, for some reason module is bad on 1024e
module load IQ-TREE/2.1.2-gompi-2020b
iqtree2 -s $WD/combined_mmoX_seqs_aligned_20perc2.fa -m MFP -nt AUTO -B 1000 -T 10


##### The tree is now complete and rerooted. Now I want to make the new graftM package ####

moduel purge
module load GraftM/0.14.0-foss-2020b
graftM create --alignment $WD/combined_mmoX_seqs_aligned_20perc2.fa \
--sequences $WD/combined_mmoX_seqs.fa --rerooted_annotated_tree  $WD/mmoX_graftM_tree_15_02_2023.tree \
 --output $WD/GraftM_mmoX_package_15_02_2023 --log $WD/graft_create.log --threads 10
