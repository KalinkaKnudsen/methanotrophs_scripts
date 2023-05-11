#!/bin/bash

#set working directory


ODIR_pmoA=/user_data/kalinka/GraftM/gtdb_dereplicated/pmoA_filtered_tree_23_01_2023
ODIR_mmoX=/user_data/kalinka/GraftM/gtdb_dereplicated/mmoX_filtered_tree_23_01_2023

WD=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps
cd $WD

### The files with all the reads must be ###

## $ODIR_pmoA/combined_hits_pmoA_filtered_23_01_2023.fa
## $ODIR_mmoX/combined_hits_mmoX_filtered_23_01_2023.fa


## Then, I do NOT want to cluster - I want to know if they pick up the same no of reads in taxas that have both pmoA and mmoX


#### Adding taxonomy from gtdb #####

## I need to add the tax from $ODIR_mmoX/genome_names_mmoX_sorted_with_gtdb.csv to the filtered file above. 

## The first step must be to only print the sequence lines 

awk -F" #" '{print $1}' $ODIR_mmoX/combined_hits_mmoX_filtered_23_01_2023.fa \
| grep ">" | sed 's/>/gtdb_/' > $ODIR_mmoX/all_mmoX_hits.txt

awk -F" #" '{print $1}' $ODIR_pmoA/combined_hits_pmoA_filtered_23_01_2023.fa \
| grep ">" | sed 's/>/gtdb_/' > $ODIR_pmoA/all_pmoA_hits.txt

awk -F, 'FNR==NR {a[$1]=$2; next} ($1 in a) {print $0","a[$1]}' \
$ODIR_mmoX/genome_names_mmoX_sorted_with_gtdb.csv $ODIR_mmoX/all_mmoX_hits.txt \
> $ODIR_mmoX/all_mmoX_hits_with_gtdb.txt

awk -F, 'FNR==NR {a[$1]=$2; next} ($1 in a) {print $0","a[$1]}' \
$ODIR_pmoA/genome_names_pmoA_sorted_with_gtdb.csv $ODIR_pmoA/all_pmoA_hits.txt \
> $ODIR_pmoA/all_pmoA_hits_with_gtdb.txt



###And making csv files instead;

cat $ODIR_mmoX/all_mmoX_hits_with_gtdb.txt | sed -E 's/;/,/g' > $ODIR_mmoX/all_mmoX_hits_with_gtdb.csv
cat $ODIR_pmoA/all_pmoA_hits_with_gtdb.txt | sed -E 's/;/,/g' > $ODIR_pmoA/all_pmoA_hits_with_gtdb.csv