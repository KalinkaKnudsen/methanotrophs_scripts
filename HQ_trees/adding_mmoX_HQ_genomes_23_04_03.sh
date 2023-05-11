#!/bin/bash

#set working directory
mmoX_seqs=/user_data/kalinka/condensed_HQ_trees/HQ_mmoX_23_04_03/gtdb_original_combined_mmoX.fa
WD=/user_data/kalinka/condensed_HQ_trees/HQ_mmoX_additions_23_14_03
cd $WD

cat $mmoX_seqs $WD/mmoX_HQ_sequences.fa > $WD/combined_mmoX.fa

##And then do the clustering here
usearch -cluster_fast $WD/combined_mmoX.fa \
-id 1 -centroids $WD/combined_mmoX_clust1.fa &> $WD/cluster_combined.log

echo "Clustering complete"

#### And then to the tree stuff ####

echo "Beginning tree building"

module purge
module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $WD/combined_mmoX_clust1.fa \
 > $WD/combined_mmoX_aligned.fa

module purge
module load TrimAl/1.4.1-foss-2020b

trimal -in $WD/combined_mmoX_aligned.fa \
 -out $WD/combined_mmoX_20pct.fa -gt 0.2

module purge
module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $WD/combined_mmoX_20pct.fa \
 -m MFP -nt AUTO -B 1000 -T 15 -redo