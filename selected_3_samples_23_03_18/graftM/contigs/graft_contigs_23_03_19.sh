#!/bin/bash

#set working directory
WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs
cd $WD

########## variables to set ################
mkdir -p $WD/mmoX
mkdir -p $WD/pmoA

ODIR_mmoX=$WD/mmoX
ODIR_pmoA=$WD/pmoA

THREADS=7

assembly=/projects/microflora_danica/deep_metagenomes/targeted/methane


############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16

# make directories for output
mkdir -p $ODIR_mmoX/graftm
mkdir -p $ODIR_mmoX/log

mkdir -p $ODIR_pmoA/graftm
mkdir -p $ODIR_pmoA/log

# temporary folder for parallel
temp=/user_data/kalinka/temp

export TMPDIR=/user_data/kalinka/temp
###############Creating seach file ########################
ls $assembly | grep '.fasta' | sed 's/_assembly.fasta//' > $WD/searchfile.txt
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward


cat $WD/searchfile.txt | parallel -j3 --tmpdir $temp graftM graft --forward $assembly/{}_assembly.fasta \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/log/{}.log


 cat $WD/searchfile.txt | parallel -j3 --tmpdir $temp graftM graft --forward $assembly/{}_assembly.fasta \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log

module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_mmoX \
-n 0 -s '\t' -p combined_count_table $WD/mmoX/graftm ConsensusLineage

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_pmoA \
-n 0 -s '\t' -p combined_count_table $WD/pmoA/graftm ConsensusLineage

sed -i 's/_assembly//g' $WD/combined_count_table_mmoX.txt
sed -i 's/_assembly//g' $WD/combined_count_table_pmoA.txt