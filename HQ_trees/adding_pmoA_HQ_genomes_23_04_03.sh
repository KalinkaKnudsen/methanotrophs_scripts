#!/bin/bash

#set working directory
pmoA_seqs=/user_data/kalinka/condensed_HQ_trees/HQ_pmoA_23_04_03/gtdb_original_combined_pmoA.fa
WD=/user_data/kalinka/condensed_HQ_trees/HQ_pmoA_additions_23_14_03
cd $WD

cat $pmoA_seqs $WD/pmoA_HQ_sequences.fa > $WD/combined_pmoA.fa

##And then do the clustering here
usearch -cluster_fast $WD/combined_pmoA.fa \
-id 1 -centroids $WD/combined_pmoA_clust1.fa &> $WD/cluster_combined.log

echo "Clustering complete"

#### And then to the tree stuff ####

echo "Beginning tree building"

module purge
module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $WD/combined_pmoA_clust1.fa \
 > $WD/combined_pmoA_aligned.fa

module purge
module load TrimAl/1.4.1-foss-2020b

trimal -in $WD/combined_pmoA_aligned.fa \
 -out $WD/combined_pmoA_20pct.fa -gt 0.2

module purge
module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $WD/combined_pmoA_20pct.fa \
 -m MFP -nt AUTO -B 1000 -T 15 -redo