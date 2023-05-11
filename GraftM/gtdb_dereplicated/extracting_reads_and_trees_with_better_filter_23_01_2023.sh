#!/bin/bash

#set working directory


ODIR_pmoA=/user_data/kalinka/GraftM/gtdb_dereplicated/pmoA_filtered_tree_23_01_2023
ODIR_mmoX=/user_data/kalinka/GraftM/gtdb_dereplicated/mmoX_filtered_tree_23_01_2023

WD=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps
cd $WD

for line in $(cat $WD/selected_genomes_pmoA.txt); do cat $WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_read_tax.tsv\
| grep -w "Root;"\
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
| grep -v "Root; pmoA_amoA_pxmA; Probably_hydrocarbon_monooxygenases; Cycloclasticus_bradhyrhizobium_cluster"\
| grep -v "Root; pmoA_amoA_pxmA; Probably_hydrocarbon_monooxygenases"\
| awk '{print $1}' \
> $WD/pmoA_hits/$line/"$line"_protein/"$line"_tax_filtered_23_01_2023.tsv;\
done


for line in $(cat $WD/selected_genomes_mmoX.txt); do cat $WD/mmoX_hits/$line/"$line"_protein/"$line"_protein_read_tax.tsv\
| grep -w "Root; likely_mmoX;"\
| awk '{print $1}' \
> $WD/mmoX_hits/$line/"$line"_protein/"$line"_tax_filtered_23_01_2023.tsv;\
done

########################### Now to the reads #######################


###OBS!!! I am now also filtering with a blast score of 100! (and so I also need to apply this when I evaluate my contigs I believe)
for line in $(cat $WD/selected_genomes_pmoA.txt); \
do awk '{ if ($3 > 240 && $17 - $16 >100 && $8 > 100) {print ">"$1}}'  \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein.hmmout.txt \
| grep -f $WD/pmoA_hits/$line/"$line"_protein/"$line"_tax_filtered_23_01_2023.tsv \
> $WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_longer_200_filtered_23_01_2023.hmmout.txt; done

for line in $(cat $WD/selected_genomes_mmoX.txt); \
do awk '{ if ($3 > 400 && $17 - $16 >100 && $8 > 100) {print ">"$1}}'  \
$WD/mmoX_hits/$line/"$line"_protein/"$line"_protein.hmmout.txt \
| grep -f $WD/mmoX_hits/$line/"$line"_protein/"$line"_tax_filtered_23_01_2023.tsv \
> $WD/mmoX_hits/$line/"$line"_protein/"$line"_protein_longer_400_filtered_23_01_2023.hmmout.txt; done



for line in $(cat $WD/selected_genomes_pmoA.txt); do grep -A1 -wf \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_longer_200_filtered_23_01_2023.hmmout.txt \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_protein_hits.fa | sed 's/--//'  | sed '/^$/d' | \
sed 's/\*$//g' > $WD/pmoA_hits/$line/"$line"_protein/"$line"_orf_long_filtered_23_01_2023.fa \
| echo $line; done

for line in $(cat $WD/selected_genomes_mmoX.txt); do grep -A1 -wf \
$WD/mmoX_hits/$line/"$line"_protein/"$line"_protein_longer_400_filtered_23_01_2023.hmmout.txt \
$WD/mmoX_hits/$line/"$line"_protein/"$line"_protein_hits.fa | sed 's/--//'  | sed '/^$/d' | \
sed 's/\*$//g' > $WD/mmoX_hits/$line/"$line"_protein/"$line"_orf_long_filtered_23_01_2023.fa \
| echo $line; done

###Contencating the files
for line in $(cat $WD/selected_genomes_pmoA.txt); do cat \
$WD/pmoA_hits/$line/"$line"_protein/"$line"_orf_long_filtered_23_01_2023.fa \
>> $ODIR_pmoA/combined_hits_pmoA_filtered_23_01_2023.fa ;done

for line in $(cat $WD/selected_genomes_mmoX.txt); do cat \
$WD/mmoX_hits/$line/"$line"_protein/"$line"_orf_long_filtered_23_01_2023.fa \
>> $ODIR_mmoX/combined_hits_mmoX_filtered_23_01_2023.fa ;done









###Clustering at 100%
usearch -cluster_fast $ODIR_pmoA/combined_hits_pmoA_filtered_23_01_2023.fa \
-id 1 -centroids $ODIR_pmoA/combined_hits_pmoA_cluster1_23_01_2023.fa

usearch -cluster_fast $ODIR_mmoX/combined_hits_mmoX_filtered_23_01_2023.fa \
-id 1 -centroids $ODIR_mmoX/combined_hits_mmoX_cluster1_23_01_2023.fa

sed -i 's/>/>gtdb_/' $ODIR_pmoA/combined_hits_pmoA_cluster1_23_01_2023.fa
sed -i 's/>/>gtdb_/' $ODIR_mmoX/combined_hits_mmoX_cluster1_23_01_2023.fa

awk -F" #" '{print $1}' $ODIR_pmoA/combined_hits_pmoA_cluster1_23_01_2023.fa  > $ODIR_pmoA/combined_hits_pmoA_cluster1_23_01_2023_fixed.fa
awk -F" #" '{print $1}' $ODIR_mmoX/combined_hits_mmoX_cluster1_23_01_2023.fa  > $ODIR_mmoX/combined_hits_mmoX_cluster1_23_01_2023_fixed.fa


##Then I want to combine the sequences from the graftM packages and the sequences here.
#I need to cat the package first - that is the sequence that is kept

cat /user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/contig_original_pmoA.fa \
$ODIR_pmoA/combined_hits_pmoA_cluster1_23_01_2023_fixed.fa > $ODIR_pmoA/combined_hits_and_graftM_pmoA_23_01_2023.fa

cat /user_data/kalinka/GraftM/GraftM_packages/mmoX_final/mmoX_sequences.faa \
$ODIR_mmoX/combined_hits_mmoX_cluster1_23_01_2023_fixed.fa > $ODIR_mmoX/combined_hits_and_graftM_mmoX_23_01_2023.fa

##And then do the clustering here
usearch -cluster_fast $ODIR_pmoA/combined_hits_and_graftM_pmoA_23_01_2023.fa \
-id 1 -centroids $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_23_01_2023.fa

usearch -cluster_fast $ODIR_mmoX/combined_hits_and_graftM_mmoX_23_01_2023.fa \
-id 1 -centroids $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_23_01_2023.fa

echo "Clustering complete"

echo "Beginning tree building"

module purge
module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_23_01_2023.fa \
 > $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_23_01_2023_aligned.fa

mafft $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_23_01_2023.fa \
 > $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_aligned_23_01_2023.fa

module purge
module load TrimAl/1.4.1-foss-2020b
trimal -in $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_23_01_2023_aligned.fa \
 -out $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_aligned_20pct_23_01_2023.fa -gt 0.2

trimal -in $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_aligned_23_01_2023.fa \
 -out $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_aligned_20pct_23_01_2023.fa -gt 0.2

module purge
module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $ODIR_pmoA/combined_hits_and_graftM_pmoA_cluster1_aligned_20pct_23_01_2023.fa \
 -m MFP -nt AUTO -B 1000 -T 10

iqtree2 -s $ODIR_mmoX/combined_hits_and_graftM_mmoX_cluster1_aligned_20pct_23_01_2023.fa \
 -m MFP -nt AUTO -B 1000 -T 10

echo "Tree building complete - use the old blast file"


#### Adding taxonomy from gtdb #####

for line in $(cat $WD/selected_genomes_mmoX.txt); do
    awk -F" #" '{print $1 "," line}' line="$line" $WD/mmoX_hits/$line/"$line"_protein/"$line"_orf_long_filtered_23_01_2023.fa \
 | grep ">" >> $ODIR_mmoX/genome_names_mmoX.txt | echo $line; done

###Then converting the tsv to csv

##Getting the mmoX taxonomy
grep -f /user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/selected_genomes_mmoX.txt \
/user_data/kalinka/GraftM/gtdb_dereplicated/bac120_taxonomy_r207.tsv > /user_data/kalinka/GraftM/gtdb_dereplicated/mmoX_gtdb_taxonomy.tsv


awk -F'\t' -v OFS=',' '{print $1,$2}' /user_data/kalinka/GraftM/gtdb_dereplicated/mmoX_gtdb_taxonomy.tsv \
| sort -t, -k1 > /user_data/kalinka/GraftM/gtdb_dereplicated/mmoX_gtdb_taxonomy_sorted.csv

sort -t, -k2 $ODIR_mmoX/genome_names_mmoX.txt > $ODIR_mmoX/genome_names_mmoX_sorted.txt


join -t, -1 2 -2 1 -o 1.1,2.2 $ODIR_mmoX/genome_names_mmoX_sorted.txt \
/user_data/kalinka/GraftM/gtdb_dereplicated/mmoX_gtdb_taxonomy_sorted.csv \
 > $ODIR_mmoX/genome_names_mmoX_sorted_with_gtdb.csv

sed -i 's/>/gtdb_/' $ODIR_mmoX/genome_names_mmoX_sorted_with_gtdb.csv








##Adding the graftM assignment###
for line in $(cat $WD/selected_genomes_pmoA.txt); do
    awk -F "\t" '{print $1 "," $2}' $WD/pmoA_hits/"$line"/"$line"_protein/"$line"_protein_read_tax.tsv \
  >> $ODIR_pmoA/pmoA_read_tax_23_01_2023.csv | echo $line; done

sed -i 's/^/gtdb_/' $ODIR_pmoA/pmoA_read_tax_23_01_2023.csv