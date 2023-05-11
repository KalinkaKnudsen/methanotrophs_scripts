#!/bin/bash

#set working directory



WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_contig_tree/extract_homologous_mmoX
module load SeqKit/2.0.0

grep ">" $WD/actino_soli_cluster.fa | awk '{print $1}' | sed 's/>//' > $WD/pattern.txt

seqkit grep -f $WD/pattern.txt /user_data/kalinka/GraftM/GraftM_packages/mmoX_contig_tree/contig_original_mmoX.fa \
-o $WD/actino_soli_cluster_seqs.fa

grep ">" $WD/Chloroflexi_cluster.fa | awk '{print $1}' | sed 's/>//' > $WD/pattern.txt

seqkit grep -f $WD/pattern.txt /user_data/kalinka/GraftM/GraftM_packages/mmoX_contig_tree/contig_original_mmoX.fa \
-o $WD/chloroflexi_soli_cluster_seqs.fa

rm $WD/pattern.txt

###### Now I want to cluster at high identity ####

usearch -cluster_fast $WD/actino_soli_cluster_seqs.fa \
-id 0.5 -centroids $WD/actino_soli_cluster_seqs_50.fa

usearch -cluster_fast $WD/chloroflexi_soli_cluster_seqs.fa \
-id 0.5 -centroids $WD/chloroflexi_soli_cluster_seqs_50.fa

###I do not want to include MFD_contig_45815_17076_6_248 - it is very long and has weird blast result
seqkit grep -v -p MFD_contig_45815_17076_6_248 $WD/chloroflexi_soli_cluster_seqs_50.fa \
 > $WD/chloroflexi_soli_cluster_seqs_cleaned_50.fa

rm $WD/chloroflexi_soli_cluster_seqs_50.fa

## I have manually added taxonomy to the contigs from blast results

##### Then moving them to the folder of the new mmoX package ###

cp $WD/chloroflexi_soli_cluster_seqs_cleaned_50.fa /user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023
cp $WD/actino_soli_cluster_seqs_50.fa /user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023