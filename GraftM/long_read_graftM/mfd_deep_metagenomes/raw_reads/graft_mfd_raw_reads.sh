#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD

########## variables to set ################

ODIR_mmoX=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/mmoX
ODIR_pmoA=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/pmoA

THREADS=10

MFD_raw=/projects/microflora_danica/deep_metagenomes/reads


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
ls $MFD_raw | grep '_R1041_trim_filt.fastq' | sed 's/_R1041_trim_filt.fastq//' > $WD/searchfile.txt
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward


cat $WD/searchfile.txt | parallel -j5 --tmpdir $temp graftM graft --forward $MFD_raw/{}_R1041_trim_filt.fastq \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/graftm/{}.log
 GRAFTM_OUT=$ODIR_mmoX



 cat $WD/searchfile.txt | parallel -j5 --tmpdir $temp graftM graft --forward $MFD_raw/{}_R1041_trim_filt.fastq \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/graftm/{}.log
 GRAFTM_OUT=$ODIR_pmoA