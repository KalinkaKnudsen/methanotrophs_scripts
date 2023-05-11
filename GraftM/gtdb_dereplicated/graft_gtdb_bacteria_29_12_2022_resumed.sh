#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps
cd $WD

########## variables to set ################
bacteria=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/bacteria
archea=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/archaea

ODIR_pmoA_bac=$WD/pmoA/bacteria

THREADS=4
############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel


GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22

# make directories for output

# temporary folder for parallel
temp=/user_data/kalinka/temp

# make your batch file of the samples you want to run
# make your batch file of the samples you want to run

#
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward

cat $WD/searchfile_bacteria_pmoA_resumed.txt | parallel -j5 --tmpdir $temp graftM graft --forward $bacteria/{}_protein.faa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA_bac/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type aminoacid --search_method hmmsearch+diamond  '&>' $ODIR_pmoA_bac/log/{}.log
 GRAFTM_OUT=$ODIR_pmoA_bac

