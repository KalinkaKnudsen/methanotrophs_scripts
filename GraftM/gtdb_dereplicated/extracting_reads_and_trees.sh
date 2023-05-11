#!/bin/bash

#set working directory
ODIR_pmoA=/user_data/kalinka/GraftM/gtdb_dereplicated/pmoA_tree_14_01_2023
ODIR_mmoX=/user_data/kalinka/GraftM/gtdb_dereplicated/mmoX_tree_14_01_2023

WD=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps
cd $WD


########################### Now to the contigs #######################

for line in $(cat $WD/selected_genomes_pmoA.txt); \
do awk '{ if ($3 > 240 && $17 - $16 >100) {print ">"$1}}'  \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein.hmmout.txt \
> $WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_longer_200.hmmout.txt; done

for line in $(cat $WD/selected_genomes_mmoX.txt);  \
do awk '{ if ($3 > 400 && $17 - $16 >100) {print ">"$1}}'  \
$WD/mmoX_hits/$line/"$line"_protein/"$line"_protein.hmmout.txt \
> $WD/mmoX_hits/$line/"$line"_protein/"$line"_protein_longer_400.hmmout.txt; done


for line in $(cat $WD/selected_genomes_pmoA.txt); do grep -A1 -wf \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_longer_200.hmmout.txt \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_hits.fa | sed 's/--//'  | sed '/^$/d' | \
sed 's/\*$//g' > $WD/pmoA_hits/$line/"$line"_protein/"$line"_orf_long.fa \
| echo $line; done

for line in $(cat $WD/selected_genomes_mmoX.txt); do grep -A1 -wf \
$WD/mmoX_hits/$line/"$line"_protein/"$line"_protein_longer_400.hmmout.txt \
$WD/mmoX_hits/$line/"$line"_protein/"$line"_protein_hits.fa | sed 's/--//'  | sed '/^$/d' | \
sed 's/\*$//g' > $WD/mmoX_hits/$line/"$line"_protein/"$line"_orf_long.fa \
| echo $line; done


###Contencating the files
for line in $(cat $WD/selected_genomes_pmoA.txt); do cat \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_orf_long.fa \
>> $ODIR_pmoA/combined_hits_pmoA.fa ;done

for line in $(cat $WD/selected_genomes_mmoX.txt); do cat \
$WD/mmoX_hits/$line/"$line"_protein/"$line"_orf_long.fa \
>> $ODIR_mmoX/combined_hits_mmoX.fa ;done


###Clustering at 100%
usearch -cluster_fast $ODIR_pmoA/combined_hits_pmoA.fa \
-id 1 -centroids $ODIR_pmoA/combined_hits_pmoA_cluster1.fa

usearch -cluster_fast $ODIR_mmoX/combined_hits_mmoX.fa \
-id 1 -centroids $ODIR_mmoX/combined_hits_mmoX_cluster1.fa

sed -i 's/>/>gtdb_/' $ODIR_pmoA/combined_hits_pmoA_cluster1.fa
sed -i 's/>/>gtdb_/' $ODIR_mmoX/combined_hits_mmoX_cluster1.fa

awk -F" #" '{print $1}' $ODIR_pmoA/combined_hits_pmoA_cluster1.fa  > $ODIR_pmoA/combined_hits_pmoA_cluster1_fixed.fa
awk -F" #" '{print $1}' $ODIR_mmoX/combined_hits_mmoX_cluster1.fa  > $ODIR_mmoX/combined_hits_mmoX_cluster1_fixed.fa


##Then I want to combine the sequences from the graftM packages and the sequences here.
#I need to cat the package first - that is the sequence that is kept

cat /user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/contig_original_pmoA.fa \
$ODIR_pmoA/combined_hits_pmoA_cluster1_fixed.fa > $ODIR_pmoA/combined_hits_and_graftM_pmoA.fa

cat /user_data/kalinka/GraftM/GraftM_packages/mmoX_final/mmoX_sequences.faa \
$ODIR_mmoX/combined_hits_mmoX_cluster1_fixed.fa > $ODIR_mmoX/combined_hits_and_graftM_mmoX.fa

##And then do the clustering here
usearch -cluster_fast $ODIR_pmoA/combined_hits_and_graftM_pmoA.fa \
-id 1 -centroids $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1.fa

usearch -cluster_fast $ODIR_mmoX/combined_hits_and_graftM_mmoX.fa \
-id 1 -centroids $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1.fa

echo "Clustering complete"

echo "Beginning tree building"

module purge
module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1.fa \
 > $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_aligned.fa

mafft $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1.fa \
 > $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_aligned.fa

module purge
module load TrimAl/1.4.1-foss-2020b
trimal -in $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_aligned.fa \
 -out $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_aligned_20pct.fa -gt 0.2

trimal -in $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_aligned.fa \
 -out $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_aligned_20pct.fa -gt 0.2

module purge
module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_aligned_20pct.fa \
 -m MFP -nt AUTO -B 1000 -T 10

iqtree2 -s $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_aligned_20pct.fa \
 -m MFP -nt AUTO -B 1000 -T 10

echo "Tree building complete - now Blasting"
####And then blasting

module purge
module load DIAMOND/2.0.9-foss-2020b

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $ODIR_pmoA/combined_hits_pmoA_cluster1_fixed.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $ODIR_pmoA/combined_hits_pmoA_blast.fa --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 10

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $ODIR_mmoX/combined_hits_mmoX_cluster1_fixed.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $ODIR_mmoX/combined_hits_mmoX_blast.fa --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 10

module purge

awk -F'\t' '{print $2" ,"$1}' $ODIR_pmoA/combined_hits_pmoA_blast.fa \
| sed -E 's/^([^,]*),.*\[/\1,[/;s/\].*$/\]/' | sed 's/ ,/,/'> $ODIR_pmoA/tax_file_pmoA_hits.csv

awk -F'\t' '{print $2" ,"$1}' $ODIR_mmoX/combined_hits_mmoX_blast.fa \
| sed -E 's/^([^,]*),.*\[/\1,[/;s/\].*$/\]/'| sed 's/ ,/,/'> $ODIR_mmoX/tax_file_mmoX_hits.csv