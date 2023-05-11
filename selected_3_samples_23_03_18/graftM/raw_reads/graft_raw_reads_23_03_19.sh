#!/bin/bash

#set working directory
WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads
cd $WD

########## variables to set ################
mkdir -p $WD/mmoX
mkdir -p $WD/pmoA

ODIR_mmoX=$WD/mmoX
ODIR_pmoA=$WD/pmoA

THREADS=8

MFD_raw=/projects/microflora_danica/deep_metagenomes/reads
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt

############################################



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



###### I need to cut sequences longer than 100,000 nucleotides;
module load SeqKit/2.0.0

mkdir -p $WD/seqs_less_100k
seqs=$WD/seqs_less_100k

cat $MFD_raw/MFD00991_R1041_trim_filt.fastq | seqkit seq -M 100000 --remove-gaps -j 10 > $seqs/MFD00991.fastq #Is currently 500k
cat $MFD_raw/MFD01188_R1041_trim_filt.fastq | seqkit seq -M 100000 --remove-gaps -j 10 > $seqs/MFD01188.fastq
cat $MFD_raw/MFD02159_R1041_trim_filt.fastq | seqkit seq -M 100000 --remove-gaps -j 10 > $seqs/MFD02159.fastq #Is currently 500k

#seqkit stats -o $seqs/MFD00991_stats.txt -j 20 $MFD_raw/MFD00991_R1041_trim_filt.fastq
#seqkit stats -o $seqs/MFD01188_stats.txt -j 20 $MFD_raw/MFD01188_R1041_trim_filt.fastq
#seqkit stats -o $seqs/MFD02159_stats.txt -j 20 $MFD_raw/MFD02159_R1041_trim_filt.fastq

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

cat $searchfile | parallel -j3 --tmpdir $temp graftM graft --forward $seqs/{}.fastq \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/log/{}.log


cat $searchfile | parallel -j3 --tmpdir $temp graftM graft --forward $seqs/{}.fastq \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log

module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_mmoX \
-n 0 -s '\t' -p combined_count_table $WD/mmoX/graftm ConsensusLineage

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_pmoA \
-n 0 -s '\t' -p combined_count_table $WD/pmoA/graftm ConsensusLineage

#sed -i 's/_R1041_trim_filt//g' $WD/combined_count_table_mmoX.txt
#sed -i 's/_R1041_trim_filt//g' $WD/combined_count_table_pmoA.txt