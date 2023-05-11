#!/bin/bash

#set working directory

WD=/user_data/kalinka/GraftM/gtdb_dereplicated
cd $WD

#### Filtering metadatafile based on completeness and contamination #####
#$3=checkm_completeness, $4 =checkm_contamination $92 is ssu_count (and ssu = small subunit ribosomal RNA (16S rRNA) ) (I could of course leave this out now that I also filter on length)

#col 99 is ssu length. I want to set this to above 1000


head -n 1 $WD/bac120_metadata_r207_mmoX.tsv > $WD/bac120_metadata_r207_mmoX_HQ.tsv
head -n 1 $WD/bac120_metadata_r207_pmoA.tsv > $WD/bac120_metadata_r207_pmoA_HQ.tsv


###Change to 90%
awk -F'\t' '{ if ($3 > 90 && $4 < 5 && $92 > 0 && $99 > 1000) {print $0}}' $WD/bac120_metadata_r207_mmoX.tsv >> $WD/bac120_metadata_r207_mmoX_HQ.tsv
awk -F'\t' '{ if ($3 > 90 && $4 < 5 && $92 > 0 && $99 > 1000) {print $0}}' $WD/bac120_metadata_r207_pmoA.tsv >> $WD/bac120_metadata_r207_pmoA_HQ.tsv

#Due to the fact that there are "," in the metadata, I need to convert the csv file (genome and seq matching) to a tsv file

sed 's/,/\t/g' $WD/mmoX_filtered_tree_23_01_2023/genome_names_mmoX_sorted.txt > $WD/mmoX_filtered_tree_23_01_2023/genome_names_mmoX_sorted.tsv
sed 's/,/\t/g' $WD/pmoA_filtered_tree_23_01_2023/genome_names_pmoA_sorted.txt > $WD/pmoA_filtered_tree_23_01_2023/genome_names_pmoA_sorted.tsv

##Now I need to add this info to the read files. awk matches column 2 of file 1 to column 1 of file 2. Then column 2 is printed twice, so I cut it with the cut command after
awk 'NR==FNR{a[$2]=$0; next} ($1 in a){print a[$1], "\t", $0}' \
$WD/mmoX_filtered_tree_23_01_2023/genome_names_mmoX_sorted.tsv $WD/bac120_metadata_r207_mmoX_HQ.tsv \
| cut -f1,3- > $WD/bac120_metadata_r207_mmoX_HQ_with_seq_id.tsv

awk 'NR==FNR{a[$2]=$0; next} ($1 in a){print a[$1], "\t", $0}' \
$WD/pmoA_filtered_tree_23_01_2023/genome_names_pmoA_sorted.tsv $WD/bac120_metadata_r207_pmoA_HQ.tsv \
| cut -f1,3- > $WD/bac120_metadata_r207_pmoA_HQ_with_seq_id.tsv