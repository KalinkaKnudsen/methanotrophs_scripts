#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM
cd $WD

########## variables to set ################
group77=/srv/MA/Projects/microflora_danica/group77

ODIR_mmoX=/user_data/kalinka/GraftM/long_read_graftM/group77/mmoX
ODIR_pmoA=/user_data/kalinka/GraftM/long_read_graftM/group77/pmoA

THREADS=30
############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b


GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022

# make directories for output
mkdir -p $ODIR_mmoX/graftm
#mkdir -p $ODIR_mmoX/log/graftm

mkdir -p $ODIR_pmoA/graftm
#mkdir -p $ODIR_pmoA/log/graftm
# temporary folder for parallel
temp=/user_data/kalinka/temp

export TMPDIR=/user_data/kalinka/temp
#
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward


graftM graft --forward $group77/assembly.fasta \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond --log $ODIR_mmoX/77.log
 GRAFTM_OUT=$ODIR_mmoX


graftM graft --forward $group77/assembly.fasta \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond --log $ODIR_pmoA/77.log
 GRAFTM_OUT=$ODIR_pmoA
