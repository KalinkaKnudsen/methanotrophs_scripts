#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA_USCg_contig
cd $WD

########## variables to set ################

ODIR_pmoA=$WD/pmoA

THREADS=10

MFD_long=/projects/microflora_danica/deep_metagenomes/assemblies


############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22

# make directories for output

mkdir -p $ODIR_pmoA/graftm

#mkdir -p $ODIR_pmoA/log/graftm
# temporary folder for parallel
temp=/user_data/kalinka/temp

export TMPDIR=/user_data/kalinka/temp
###############Creating seach file ########################
ls $MFD_long | grep '.fasta' | sed 's/.fasta//' > $WD/searchfile.txt
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward


 cat $WD/searchfile.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD_long/{}.fasta \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/graftm/{}.log
 GRAFTM_OUT=$ODIR_pmoA