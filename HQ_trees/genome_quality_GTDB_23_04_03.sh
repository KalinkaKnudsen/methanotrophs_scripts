#!/bin/bash

#set working directory


mmoX_seqs=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/mmoX_hits
pmoA_seqs=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/pmoA_hits
WD=/user_data/kalinka/condensed_HQ_trees
cd $WD

genomes_pmoA=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/selected_genomes_pmoA.txt
genomes_mmoX=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/selected_genomes_mmoX.txt

mkdir /user_data/kalinka/condensed_HQ_trees/HQ_mmoX_23_04_03
mkdir /user_data/kalinka/condensed_HQ_trees/HQ_pmoA_23_04_03

########### I have combined everything is this script from after the graftM #########
ODIR_pmoA=/user_data/kalinka/condensed_HQ_trees/HQ_pmoA_23_04_03
ODIR_mmoX=/user_data/kalinka/condensed_HQ_trees/HQ_mmoX_23_04_03


for line in $(cat $genomes_pmoA); do cat $pmoA_seqs/$line/"$line"_protein/"$line"_protein_read_tax.tsv\
| grep -w "Root; pmoA_amoA_pxmA;"\
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira; Nitrospira_clade_B"\
| grep -v "Root; pmoA_amoA_pxmA; amoA; Betaproteobacteria_amoA"\
| grep -v "Root; pmoA_amoA_pxmA; amoA"\
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira; Nitrospira_clade_A"\
| grep -v "Root; pmoA_amoA_pxmA; amoA; Nitrospira"\
| grep -v "Root; pmoA_amoA_pxmA; pmoA; Nitrosococcus"\
| grep -v "Root; pmoA_amoA_pxmA; pmoA; Cycloclasticus"\
| grep -v "Root; pmoA_amoA_pxmA; Probably_hydrocarbon_monooxygenases; Cycloclasticus_bradhyrhizobium_cluster" \
| grep -v "Root; pmoA_amoA_pxmA; Probably_hydrocarbon_monooxygenases"\
| grep -v "Root; pmoA_amoA_pxmA; Probably_hydrocarbon_monooxygenases; Homologous_perhaps_burkholderiales" \
| awk '{print $1}' \
> $pmoA_seqs/$line/"$line"_protein/"$line"_tax_filtered_23_04_03.tsv;\
done


for line in $(cat $genomes_mmoX); do cat $mmoX_seqs/$line/"$line"_protein/"$line"_protein_read_tax.tsv\
| grep -w "Root; likely_mmoX;"\
| awk '{print $1}' \
> $mmoX_seqs/$line/"$line"_protein/"$line"_tax_filtered_23_04_03.tsv;\
done

########################### Now to the reads #######################

#### So the sequences >gtdb_NC_007484.1_2661 and >gtdb_CAIXED010000021.1_25 are both pmoB sequences. 
#Previously, I filtered based on score/value as well as length. That could be the only way around this. And probably include this in the graftM package as well. 
## If I choose to include e-value filter, I must test it on the packages as well!! 

#NC_007484.1_2661     -            417 graftmulk_7zdp.aln   -            520   2.3e-06   24.8
#CAIXED010000021.1_25 -            414 graftmulk_7zdp.aln   -            520     3e-09   34.0 

#So a score cutoff could be <1e-10

##### Filtering by length only ######
for line in $(cat $genomes_pmoA); \
do awk '{ if ($3 > 240 && $7 < 1e-10) {print $1}}' \
$pmoA_seqs/$line/"$line"_protein/"$line"_protein.hmmout.txt \
| grep -f $pmoA_seqs/$line/"$line"_protein/"$line"_tax_filtered_23_04_03.tsv \
> $pmoA_seqs/$line/"$line"_protein/"$line"_protein_longer_200_filtered_23_04_03.hmmout.txt; done

for line in $(cat $genomes_mmoX); \
do awk '{ if ($3 > 400 && $7 < 1e-10) {print $1}}'  \
$mmoX_seqs/$line/"$line"_protein/"$line"_protein.hmmout.txt \
| grep -f $mmoX_seqs/$line/"$line"_protein/"$line"_tax_filtered_23_04_03.tsv \
> $mmoX_seqs/$line/"$line"_protein/"$line"_protein_longer_400_filtered_23_04_03.hmmout.txt; done



for line in $(cat $genomes_pmoA); do grep -A1 --no-group-separator -f \
$pmoA_seqs/$line/"$line"_protein/"$line"_protein_longer_200_filtered_23_04_03.hmmout.txt \
$pmoA_seqs/$line/"$line"_protein/"$line"_protein_hits.fa \
> $pmoA_seqs/$line/"$line"_protein/"$line"_orf_long_filtered_23_04_03.fa \
| echo $line; done

for line in $(cat $genomes_mmoX); do grep -A1 --no-group-separator -f \
$mmoX_seqs/$line/"$line"_protein/"$line"_protein_longer_400_filtered_23_04_03.hmmout.txt \
$mmoX_seqs/$line/"$line"_protein/"$line"_protein_hits.fa \
> $mmoX_seqs/$line/"$line"_protein/"$line"_orf_long_filtered_23_04_03.fa \
| echo $line; done

###Contencating the files
for line in $(cat $genomes_pmoA); do cat \
$pmoA_seqs/$line/"$line"_protein/"$line"_orf_long_filtered_23_04_03.fa \
>> $ODIR_pmoA/combined_hits_pmoA_filtered_23_04_03.fa ;done

for line in $(cat $genomes_mmoX); do cat \
$mmoX_seqs/$line/"$line"_protein/"$line"_orf_long_filtered_23_04_03.fa \
>> $ODIR_mmoX/combined_hits_mmoX_filtered_23_04_03.fa ;done


###Clustering at 100%
usearch -cluster_fast $ODIR_pmoA/combined_hits_pmoA_filtered_23_04_03.fa \
-id 1 -centroids $ODIR_pmoA/combined_hits_pmoA_cluster1_23_04_03.fa &> $ODIR_pmoA/cluster.log

usearch -cluster_fast $ODIR_mmoX/combined_hits_mmoX_filtered_23_04_03.fa \
-id 1 -centroids $ODIR_mmoX/combined_hits_mmoX_cluster1_23_04_03.fa &> $ODIR_mmoX/cluster.log

sed -i 's/>/>gtdb_/' $ODIR_pmoA/combined_hits_pmoA_cluster1_23_04_03.fa
sed -i 's/>/>gtdb_/' $ODIR_mmoX/combined_hits_mmoX_cluster1_23_04_03.fa

awk -F" #" '{print $1}' $ODIR_pmoA/combined_hits_pmoA_cluster1_23_04_03.fa  > $ODIR_pmoA/combined_hits_pmoA_cluster1_23_04_03_fixed.fa
awk -F" #" '{print $1}' $ODIR_mmoX/combined_hits_mmoX_cluster1_23_04_03.fa  > $ODIR_mmoX/combined_hits_mmoX_cluster1_23_04_03_fixed.fa

rm $ODIR_pmoA/combined_hits_pmoA_cluster1_23_04_03.fa
rm $ODIR_mmoX/combined_hits_mmoX_cluster1_23_04_03.fa

######## Previously, I then concatenated at this step. However, I need to filter based on genome quality before I concatenate the two, because I only want HQ stuff

#### Filtering metadatafile based on completeness and contamination #####
#$3=checkm_completeness, $4 =checkm_contamination $92 is ssu_count (and ssu = small subunit ribosomal RNA (16S rRNA) ) (I could of course leave this out now that I also filter on length)

#col 99 is ssu length. I want to set this to above 1000

wd_gtdb=/user_data/kalinka/GraftM/gtdb_dereplicated

###The metadata files for mmoX and pmoA have been made by;
grep -f $genomes_pmoA $wd_gtdb/bac120_metadata_r207.tsv | \
awk -F'\t' '{ if ($3 > 90 && $4 < 5 && $92 > 0 && $99 > 1000) {print $0}}' \
| sort -k1 > $ODIR_pmoA/bac120_metadata_r207_pmoA_HQ.tsv

grep -f $genomes_mmoX $wd_gtdb/bac120_metadata_r207.tsv | \
awk -F'\t' '{ if ($3 > 90 && $4 < 5 && $92 > 0 && $99 > 1000) {print $0}}' \
| sort -k1 > $ODIR_mmoX/bac120_metadata_r207_mmoX_HQ.tsv

####### Now I have the HQ-genomes. I then want to remove any sequences that are not HQ ######
############# Making a file that connects genome name to sequence ####################
for line in $(cat $genomes_pmoA); do
    awk -F" #" '{print $1 "," line}' line="$line" $pmoA_seqs/$line/"$line"_protein/"$line"_orf_long_filtered_23_04_03.fa \
 | grep ">" | sed 's/>/gtdb_/' | sed 's/,/\t/g' >> $ODIR_pmoA/genome_names_pmoA.txt | echo $line; done
sort -k2 $ODIR_pmoA/genome_names_pmoA.txt > $ODIR_pmoA/genome_names_pmoA_sorted.tsv
rm $ODIR_pmoA/genome_names_pmoA.txt


for line in $(cat $genomes_mmoX); do
    awk -F" #" '{print $1 "," line}' line="$line" $mmoX_seqs/$line/"$line"_protein/"$line"_orf_long_filtered_23_04_03.fa \
 | grep ">" | sed 's/>/gtdb_/' | sed 's/,/\t/g' >> $ODIR_mmoX/genome_names_mmoX.txt | echo $line; done
sort -k2 $ODIR_mmoX/genome_names_mmoX.txt > $ODIR_mmoX/genome_names_mmoX_sorted.tsv
rm $ODIR_mmoX/genome_names_mmoX.txt


##Now I need to add this info to each sequence extracted by graftM. awk matches column 2 of file 1 to column 1 of file 2. Then column 2 is printed twice, so I cut it with the cut command after
awk 'NR==FNR{a[$2]=$0; next} ($1 in a){print a[$1], "\t", $0}' \
 $ODIR_mmoX/genome_names_mmoX_sorted.tsv $ODIR_mmoX/bac120_metadata_r207_mmoX_HQ.tsv \
| cut -f1,3- > $ODIR_mmoX/bac120_metadata_r207_mmoX_HQ_with_seq_id.tsv

awk 'NR==FNR{a[$2]=$0; next} ($1 in a){print a[$1], "\t", $0}' \
 $ODIR_pmoA/genome_names_pmoA_sorted.tsv $ODIR_pmoA/bac120_metadata_r207_pmoA_HQ.tsv \
| cut -f1,3- > $ODIR_pmoA/bac120_metadata_r207_pmoA_HQ_with_seq_id.tsv


### Now to the "original" sequences. ###

#First step is to remove all instances of "No" and also turn the files into tsv files. 
awk -F';' '{if ($2 !~ /No/) print $1,"\t",$2}' $WD/HQ_pmoA/pmoA_genomes_2_2_2023.csv \
| grep -v Col | dos2unix  > $ODIR_pmoA/pmoA_seqs_with_genomes.tsv
sed -i 's/\t /\t/' $ODIR_pmoA/pmoA_seqs_with_genomes.tsv

awk -F';' '{if ($2 !~ /No/) print $1,"\t",$2}' $WD/HQ_mmoX/mmoX_genomes_2_2_2023.csv \
| grep -v Col | dos2unix  > $ODIR_mmoX/mmoX_seqs_with_genomes.tsv
sed -i 's/\t /\t/' $ODIR_mmoX/mmoX_seqs_with_genomes.tsv

#### Then, I am selecting only HQ genomes ####
awk -F'\t' '{print $2}' $ODIR_pmoA/pmoA_seqs_with_genomes.tsv | grep -f - $wd_gtdb/bac120_metadata_r207.tsv | \
awk -F'\t' '{ if ($3 > 90 && $4 < 5 && $92 > 0 && $99 > 1000) {print $0}}' \
| sort -k1 > $ODIR_pmoA/pmoA_original_gtdb_matching.tsv

awk -F'\t' '{print $2}' $ODIR_mmoX/mmoX_seqs_with_genomes.tsv | grep -f - $wd_gtdb/bac120_metadata_r207.tsv | \
awk -F'\t' '{ if ($3 > 90 && $4 < 5 && $92 > 0 && $99 > 1000) {print $0}}' \
| sort -k1 > $ODIR_mmoX/mmoX_original_gtdb_matching.tsv

##### Then combining this with the seq_ID ####
awk -F'\t' 'NR==FNR{a[$2]=$1; next} ($1 in a){print a[$1], "\t", $0}' \
$ODIR_mmoX/mmoX_seqs_with_genomes.tsv $ODIR_mmoX/mmoX_original_gtdb_matching.tsv \
> $ODIR_mmoX/mmoX_original_gtdb_matching_ID.tsv

awk -F'\t' 'NR==FNR{a[$2]=$1; next} ($1 in a){print a[$1], "\t", $0}' \
$ODIR_pmoA/pmoA_seqs_with_genomes.tsv $ODIR_pmoA/pmoA_original_gtdb_matching.tsv \
> $ODIR_pmoA/pmoA_original_gtdb_matching_ID.tsv

###### I do not want to include anything from the "initial" MFD-samples. The story needs to be what was already present! ######
### So, I need to first add the sequences from the genomes, and then the sequences from the original packages. 
module load SeqKit/2.0.0

cat $ODIR_pmoA/bac120_metadata_r207_pmoA_HQ_with_seq_id.tsv | cut -f 1 | \
seqkit grep -f - $ODIR_pmoA/combined_hits_pmoA_cluster1_23_04_03_fixed.fa > $ODIR_pmoA/gtdb_original_combined_pmoA.fa
cat $ODIR_pmoA/pmoA_original_gtdb_matching_ID.tsv | cut -f 1 | cut -d ' ' -f 1 | seqkit grep -f - \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.fa \
>> $ODIR_pmoA/gtdb_original_combined_pmoA.fa


cat $ODIR_mmoX/bac120_metadata_r207_mmoX_HQ_with_seq_id.tsv | cut -f 1 | \
seqkit grep -f - $ODIR_mmoX/combined_hits_mmoX_cluster1_23_04_03_fixed.fa > $ODIR_mmoX/gtdb_original_combined_mmoX.fa
cat $ODIR_mmoX/mmoX_original_gtdb_matching_ID.tsv | cut -f 1 | cut -d ' ' -f 1 | seqkit grep -f - \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.fa \
>> $ODIR_mmoX/gtdb_original_combined_mmoX.fa

#### However, I need to have the outgroup sequences regardless of their HQ status to make the tree nice 
grep -E "Homologous_MO|HMO_cluster|Actinobacteria" \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/pmoA_package_23_03_16.refpkg/align_pmoA_combined_seqinfo.csv \
| grep -v "MFD" | cut -d"," -f1 | seqkit grep -f - /user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.fa \
>> $ODIR_pmoA/gtdb_original_combined_pmoA.fa


grep -E "Homologous_mmoX|Propane_monooxygenase|Butane_monooxygenase" \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/mmoX_package_23_03_19.refpkg/combined_mmoX_seqs_seqinfo.csv \
| grep -v "MFD" | cut -d"," -f1 | seqkit grep -f - /user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.fa \
>> $ODIR_mmoX/gtdb_original_combined_mmoX.fa

##And then do the clustering here
usearch -cluster_fast $ODIR_pmoA/gtdb_original_combined_pmoA.fa \
-id 1 -centroids $ODIR_pmoA/gtdb_original_combined_pmoA_cluster1.fa &> $ODIR_pmoA/cluster_combined.log

usearch -cluster_fast $ODIR_mmoX/gtdb_original_combined_mmoX.fa \
-id 1 -centroids $ODIR_mmoX/gtdb_original_combined_mmoX_cluster1.fa &> $ODIR_mmoX/cluster_combined.log

echo "Clustering complete"


#### And then to the tree stuff ####
mkdir $ODIR_mmoX/tree
mkdir $ODIR_pmoA/tree


echo "Beginning tree building"

module purge
module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $ODIR_pmoA/gtdb_original_combined_pmoA_cluster1.fa \
 > $ODIR_pmoA/tree/gtdb_original_combined_pmoA_aligned.fa

mafft $ODIR_mmoX/gtdb_original_combined_mmoX_cluster1.fa \
 > $ODIR_mmoX/tree/gtdb_original_combined_mmoX_aligned.fa

module purge
module load TrimAl/1.4.1-foss-2020b

trimal -in $ODIR_pmoA/tree/gtdb_original_combined_pmoA_aligned.fa \
 -out $ODIR_pmoA/tree/gtdb_original_combined_pmoA_aligned_20pct.fa -gt 0.2

trimal -in $ODIR_mmoX/tree/gtdb_original_combined_mmoX_aligned.fa \
 -out $ODIR_mmoX/tree/gtdb_original_combined_mmoX_aligned_20pct.fa -gt 0.2

module purge
module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $ODIR_pmoA/tree/gtdb_original_combined_pmoA_aligned_20pct.fa \
 -m MFP -nt AUTO -B 1000 -T 10 -redo

iqtree2 -s $ODIR_mmoX/tree/gtdb_original_combined_mmoX_aligned_20pct.fa \
 -m MFP -nt AUTO -B 1000 -T 10 -redo



#### Making a tax file 
awk -F"\t" -v OFS="," '{print $1, $18}'  $ODIR_pmoA/bac120_metadata_r207_pmoA_HQ_with_seq_id.tsv \
| awk -F";" -v OFS="," '{print $1, $4 " " $7}' - | sed 's/d__Bacteria,//' \
> $ODIR_pmoA/tree/tax_pmoA.csv

awk -F"\t" -v OFS="," '{print $1, $18}'  $ODIR_mmoX/bac120_metadata_r207_mmoX_HQ_with_seq_id.tsv \
| awk -F";" -v OFS="," '{print $1, $4 " " $7}' - | sed 's/d__Bacteria,//' \
> $ODIR_mmoX/tree/tax_mmoX.csv

#Appending the info from the "original" sequences
awk -F"\t" -v OFS="," '{split($1, a, " "); print a[1], $18}' $ODIR_pmoA/pmoA_original_gtdb_matching_ID.tsv \
| awk -F";" -v OFS="," '{print $1, $4 " " $7}' - | sed 's/d__Bacteria,//' \
>> $ODIR_pmoA/tree/tax_pmoA.csv

awk -F"\t" -v OFS="," '{split($1, a, " "); print a[1], $18}' $ODIR_mmoX/mmoX_original_gtdb_matching_ID.tsv \
| awk -F";" -v OFS="," '{print $1, $4 " " $7}' - | sed 's/d__Bacteria,//' \
>> $ODIR_mmoX/tree/tax_mmoX.csv