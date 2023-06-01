#!/bin/bash

#set working directory
WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs
cd $WD

########## variables to set ################


ODIR_pmoA=/user_data/kalinka/GraftM/GraftM_packages/testing_e_value_23_04_18
mkdir -p $ODIR_pmoA/new_package_1_HMM

THREADS=7

assembly=/projects/microflora_danica/deep_metagenomes/targeted/methane

module purge
module load GraftM/0.14.0-foss-2020b
module load parallel
temp=/user_data/kalinka/temp
export TMPDIR=/user_data/kalinka/temp
##Investigate the effects of;
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16

cat $WD/searchfile.txt | parallel -j3 --tmpdir $temp graftM graft --forward $assembly/{}_assembly.fasta \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --evalue 1e-10 \
 --threads 5 --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log


GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_04_18

### Not suprising, it just cuts at a set E-value
## I will also test the new package on the contigs just to see
cat $WD/searchfile.txt | parallel -j3 --tmpdir $temp graftM graft --forward $assembly/{}_assembly.fasta \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/new_package_1_HMM/{}  \
 --threads 5 --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/new_package_1_HMM/{}.log

###Trying to set the E-value for the entire sequence
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_04_18
mkdir -p $ODIR_pmoA/new_e_value

cat $WD/searchfile.txt | parallel -j3 --tmpdir $temp graftM graft --forward $assembly/{}_assembly.fasta \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/new_e_value/{} --evalue 1e-10 \
 --threads 5 --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/new_e_value/{}.log


python3 /user_data/kalinka/join_files.py -e txt -f /user_data/kalinka/GraftM/GraftM_packages/testing_e_value_23_04_18/combined \
-n 0 -s '\t' -p table_pmoA /user_data/kalinka/GraftM/GraftM_packages/testing_e_value_23_04_18/pmoA ConsensusLineage