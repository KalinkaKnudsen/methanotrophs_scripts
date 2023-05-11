#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD

########## variables to set ################

ODIR_mmoX=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/proovframe/correcting_MFD01138_MFD10064/mmoX
ODIR_pmoA=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/proovframe/correcting_MFD01138_MFD10064/pmoA

THREADS=10


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
###############Creating seach file ########################

graftM graft --forward $ODIR_mmoX/MFD01138_corrected.fa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/MFD01138 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond --log $ODIR_mmoX/MFD01138.log
 GRAFTM_OUT=$ODIR_mmoX

graftM graft --forward $ODIR_mmoX/MFD10064_corrected.fa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/MFD10064 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond --log $ODIR_mmoX/MFD10064.log
 GRAFTM_OUT=$ODIR_mmoX


 graftM graft --forward $ODIR_pmoA/MFD01138_corrected.fa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/MFD01138 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond --log $ODIR_pmoA/MFD01138.log
 GRAFTM_OUT=$ODIR_pmoA


graftM graft --forward $ODIR_pmoA/MFD10064_corrected.fa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/MFD10064 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond --log $ODIR_pmoA/MFD10064.log
 GRAFTM_OUT=$ODIR_pmoA


 module purge