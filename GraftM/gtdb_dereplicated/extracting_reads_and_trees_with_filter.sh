#!/bin/bash

#set working directory


ODIR_pmoA=/user_data/kalinka/GraftM/gtdb_dereplicated/pmoA_filtered_tree_16_01_2023
ODIR_mmoX=/user_data/kalinka/GraftM/gtdb_dereplicated/mmoX_filtered_tree_16_01_2023

WD=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps
cd $WD

for line in $(cat $WD/selected_genomes_pmoA.txt); do cat $WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_read_tax.tsv\
| grep -e "Root;"\
| grep -v "Root; Homologous_pmoA" \
| grep -v "Root; Homologous_pmoA; HMO_cluster" \
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira; Nitrospira_clade_B" \
| grep -v "Root; pmoA_amoA_pxmA; amoA; Betaproteobacteria_amoA" \
| grep -v "Root; pmoA_amoA_pxmA; amoA"\
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira; Nitrospira_clade_A" \
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira"\
| grep -v "Root; Homologous_pmoA; Actinobacteria" \
| grep -v "Root; Homologous_pmoA; Deltaproteobacteria_Binataceae_cluster; HMO_group_1"\
| grep -v "Root; pmoA_amoA_pxmA; pmoA; Nitrosococcus"\
| grep -v "Root; pmoA_amoA_pxmA; pmoA; Cycloclasticus"\
| awk '{print $1}' \
> $WD/pmoA_hits/$line/"$line"_protein/"$line"_tax_filtered.tsv;\
done

########################### Now to the reads #######################

for line in $(cat $WD/selected_genomes_pmoA.txt); \
do awk '{ if ($3 > 240 && $17 - $16 >100) {print ">"$1}}'  \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein.hmmout.txt \
| grep -f $WD/pmoA_hits/$line/"$line"_protein/"$line"_tax_filtered.tsv \
> $WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_longer_200_filtered.hmmout.txt; done


#### Remember that you have filtered in R for the mmoX ####

for line in $(cat $ODIR_mmoX/selected_genomes_mmoX_gtdb.txt);  \
do awk '{ if ($3 > 400 && $17 - $16 >100) {print ">"$1}}'  \
$ODIR_mmoX/filtered_mmoX_selection/$line/"$line"_protein/"$line"_protein.hmmout.txt \
> $ODIR_mmoX/filtered_mmoX_selection/$line/"$line"_protein/"$line"_protein_longer_400_filtered.hmmout.txt; done


for line in $(cat $WD/selected_genomes_pmoA.txt); do grep -A1 -wf \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_longer_200_filtered.hmmout.txt \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_hits.fa | sed 's/--//'  | sed '/^$/d' | \
sed 's/\*$//g' > $WD/pmoA_hits/$line/"$line"_protein/"$line"_orf_long_filtered.fa \
| echo $line; done

for line in $(cat $ODIR_mmoX/selected_genomes_mmoX_gtdb.txt); do grep -A1 -wf \
$ODIR_mmoX/filtered_mmoX_selection/$line/"$line"_protein/"$line"_protein_longer_400_filtered.hmmout.txt \
$ODIR_mmoX/filtered_mmoX_selection/$line/"$line"_protein/"$line"_protein_hits.fa | sed 's/--//'  | sed '/^$/d' | \
sed 's/\*$//g' > $ODIR_mmoX/filtered_mmoX_selection/$line/"$line"_protein/"$line"_orf_long_filtered.fa \
| echo $line; done


###Contencating the files
for line in $(cat $WD/selected_genomes_pmoA.txt); do cat \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_orf_long_filtered.fa \
>> $ODIR_pmoA/combined_hits_pmoA_filtered.fa ;done

for line in $(cat $ODIR_mmoX/selected_genomes_mmoX_gtdb.txt); do cat \
$ODIR_mmoX/filtered_mmoX_selection/$line/"$line"_protein/"$line"_orf_long_filtered.fa \
>> $ODIR_mmoX/combined_hits_mmoX_filtered.fa ;done


############# Making a genome name file ####################
for line in $(cat $WD/selected_genomes_pmoA.txt); do
    awk -F" #" '{print $1 "," line}' line="$line" $WD/pmoA_hits/$line/"$line"_protein/"$line"_orf_long_filtered.fa \
 | grep ">" >> $ODIR_pmoA/genome_names_pmoA.txt | echo $line; done

###Then converting the tsv to csv


awk -F'\t' -v OFS=',' '{print $1,$2}' /user_data/kalinka/GraftM/gtdb_dereplicated/pmoA_gtdb_taxonomy.tsv \
| sort -t, -k1 > /user_data/kalinka/GraftM/gtdb_dereplicated/pmoA_gtdb_taxonomy_sorted.csv

sort -t, -k2 $ODIR_pmoA/genome_names_pmoA.txt > $ODIR_pmoA/genome_names_pmoA_sorted.txt


join -t, -1 2 -2 1 -o 1.1,2.2 $ODIR_pmoA/genome_names_pmoA_sorted.txt \
/user_data/kalinka/GraftM/gtdb_dereplicated/pmoA_gtdb_taxonomy_sorted.csv \
 > $ODIR_pmoA/genome_names_pmoA_sorted_with_gtdb.csv

sed -i 's/>/gtdb_/' $ODIR_pmoA/genome_names_pmoA_sorted_with_gtdb.csv



###Clustering at 100%
usearch -cluster_fast $ODIR_pmoA/combined_hits_pmoA_filtered.fa \
-id 1 -centroids $ODIR_pmoA/combined_hits_pmoA_cluster1.fa

usearch -cluster_fast $ODIR_mmoX/combined_hits_mmoX_filtered.fa \
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

echo "Tree building complete - use the old blast file"