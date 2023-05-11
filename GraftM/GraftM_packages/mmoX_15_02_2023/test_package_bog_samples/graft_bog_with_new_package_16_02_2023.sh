#!/bin/bash

#set working directory
samples=/user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/shallow_selected_samples/mmoX
WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/test_package_bog_samples
seq_id=/user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/bogs_seqid.txt
cd $WD

### Then I want to run graftM on the extracted samples 
# Set variables
mkdir -p $WD/graftm
ODIR_mmoX=$WD/graftm
THREADS=5
GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/GraftM_mmoX_package_15_02_2023

############################################
# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

# temporary folder for parallel
temp=/user_data/kalinka/temp

cat $seq_id | parallel -j4 --tmpdir $temp graftM graft --forward \
$samples/{}/{}_R1_fastp/{}_R1_fastp_orf.fa --graftm_package $GRAFTM_PACKAGE_mmoX \
--output_directory $ODIR_mmoX/{} --verbosity 5 --threads $THREADS --force --input_sequence_type aminoacid \
--search_method hmmsearch+diamond  '&>' $ODIR_mmoX/{}.log

##Then combining the output
module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_mmoX \
-n 0 -s '\t' -p combined_count_table $ODIR_mmoX ConsensusLineage

sed -i 's/_R1_fastp_orf//g' $WD/combined_count_table_mmoX.txt