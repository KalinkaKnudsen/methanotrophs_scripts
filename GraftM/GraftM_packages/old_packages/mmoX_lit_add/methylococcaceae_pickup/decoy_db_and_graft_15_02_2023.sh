#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup
cd $WD

### Then I want to run graftM on the extracted samples 
# Set variables
mkdir -p $WD/graftm_decoy_15_02_2023
ODIR_mmoX=$WD/graftm_decoy_15_02_2023
mkdir -p $ODIR_mmoX/graftm
mkdir -p $ODIR_mmoX/log
THREADS=5
GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022

############################################
# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

# temporary folder for parallel
temp=/user_data/kalinka/temp

### Lige en lille tester
#graftM graft --forward $WD/selection_shallow_21_12_2022/LIB-MJ044-H1-03/LIB-MJ044-H1-03_R1_fastp/LIB-MJ044-H1-03_R1_fastp_orf.fa \
# --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX --threads 5 \
# --force --input_sequence_type aminoacid --log $ODIR_mmoX/myco.log  \
# --verbosity 5 --decoy_database $WD/propane.dmnd

cat $WD/unique_seqids.txt | parallel -j2 --tmpdir $temp graftM graft --forward \
$WD/selection_shallow_21_12_2022/{}/{}_R1_fastp/{}_R1_fastp_orf.fa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type aminoacid --decoy_database $WD/propane.dmnd  '&>' $ODIR_mmoX/log/{}.log



#### It is not possible to do both --search_method hmmsearch+diamond and --decoy_database. 
#So, I will try to include the homologous sequences in the tree instead - afterwards
#But for now I want to be able to see difference in the output across the samples


##Then combining the output
module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_mmoX \
-n 0 -s '\t' -p combined_count_table $ODIR_mmoX/graftm ConsensusLineage

sed -i 's/_R1_fastp_orf//g' $WD/combined_count_table_mmoX.txt