#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/ANME_sediment_01_02_2023
cd $WD

SED112=/projects/ANME_2023/processing/mmlong/SED112-1_mmlong/results/bins
SED114=/projects/ANME_2023/processing/mmlong/SED114-1_mmlong/results/bins
SED134=/projects/ANME_2023/processing/mmlong/SED134-1_mmlong/results/bins


########## variables to set ################

ODIR_mmoX=$WD/mmoX
ODIR_pmoA=$WD/pmoA

THREADS=6


############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22

# make directories for output
mkdir -p $ODIR_mmoX/graftm
mkdir -p $ODIR_mmoX/log

mkdir -p $ODIR_pmoA/graftm
mkdir -p $ODIR_pmoA/log
# temporary folder for parallel
temp=/user_data/kalinka/temp

export TMPDIR=/user_data/kalinka/temp
###############Creating seach file ########################
ls $SED112 | grep '.fa' | sed 's/.fa//' > $WD/searchfile.txt
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward

cat $WD/searchfile.txt | parallel -j5 --tmpdir $temp graftM graft --forward $SED112/{}.fa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile.txt | parallel -j5 --tmpdir $temp graftM graft --forward $SED112/{}.fa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
 GRAFTM_OUT=$ODIR_pmoA



#### SED114
ls $SED114 | grep '.fa' | sed 's/.fa//' > $WD/searchfile.txt

cat $WD/searchfile.txt | parallel -j5 --tmpdir $temp graftM graft --forward $SED114/{}.fa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile.txt | parallel -j5 --tmpdir $temp graftM graft --forward $SED114/{}.fa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
 GRAFTM_OUT=$ODIR_pmoA



###SED134
ls $SED134 | grep '.fa' | sed 's/.fa//' > $WD/searchfile.txt

cat $WD/searchfile.txt | parallel -j5 --tmpdir $temp graftM graft --forward $SED134/{}.fa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile.txt | parallel -j5 --tmpdir $temp graftM graft --forward $SED134/{}.fa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
 GRAFTM_OUT=$ODIR_pmoA


rm($WD/searchfile.txt)