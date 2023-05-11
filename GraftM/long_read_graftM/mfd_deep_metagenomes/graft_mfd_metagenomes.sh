#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes
cd $WD

########## variables to set ################

ODIR_mmoX=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX
ODIR_pmoA=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA

THREADS=10

MFD_long=/projects/microflora_danica/deep_metagenomes/assemblies


############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

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
ls $MFD_long | grep '.fasta' | sed 's/.fasta//' > $WD/searchfile1.txt
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward


cat $WD/searchfile1.txt | parallel -j10 --tmpdir $temp graftM graft --forward $MFD_long/{}.fasta \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/graftm/{}.log
 GRAFTM_OUT=$ODIR_mmoX


 cat $WD/searchfile1.txt | parallel -j10 --tmpdir $temp graftM graft --forward $MFD_long/{}.fasta \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/graftm/{}.log
 GRAFTM_OUT=$ODIR_pmoA