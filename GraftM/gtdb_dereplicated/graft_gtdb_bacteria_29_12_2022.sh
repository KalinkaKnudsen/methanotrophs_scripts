#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps
cd $WD

########## variables to set ################
bacteria=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/bacteria
archea=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/archaea

mkdir -p $WD/mmoX/bacteria
mkdir -p $WD/pmoA/bacteria

ODIR_mmoX_bac=$WD/mmoX/bacteria
ODIR_pmoA_bac=$WD/pmoA/bacteria

THREADS=10
############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel


GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22

# make directories for output
mkdir -p $ODIR_mmoX_bac/graftm
mkdir -p $ODIR_mmoX_bac/log

mkdir -p $ODIR_pmoA_bac/graftm
mkdir -p $ODIR_pmoA_bac/log
# temporary folder for parallel
temp=/user_data/kalinka/temp

# make your batch file of the samples you want to run
# make your batch file of the samples you want to run
ls $bacteria | grep '_protein.faa' | sed 's/_protein.faa//' > $WD/searchfile_bacteria.txt
#
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward
cat $WD/searchfile_bacteria.txt | parallel -j8 --tmpdir $temp graftM graft --forward $bacteria/{}_protein.faa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX_bac/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type aminoacid --search_method hmmsearch+diamond  '&>' $ODIR_mmoX_bac/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX_bac

cat $WD/searchfile_bacteria.txt | parallel -j8 --tmpdir $temp graftM graft --forward $bacteria/{}_protein.faa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA_bac/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type aminoacid --search_method hmmsearch+diamond  '&>' $ODIR_pmoA_bac/log/{}.log
 GRAFTM_OUT=$ODIR_pmoA_bac

