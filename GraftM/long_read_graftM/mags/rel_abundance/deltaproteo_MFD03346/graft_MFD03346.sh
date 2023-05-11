#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mags/rel_abundance/deltaproteo_MFD03346
cd $WD

########## variables to set ################
mkdir -p $WD/graftm
mkdir -p $WD/log

GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22


THREADS=5

MFD=/projects/microflora_danica/deep_metagenomes/processing/MFD03346/results/bins


############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel


temp=/user_data/kalinka/temp

export TMPDIR=/user_data/kalinka/temp
###############Creating seach file ########################
ls $MFD | grep '.fa' | sed 's/.fa//' > $WD/searchfile.txt
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward


cat $WD/searchfile.txt | parallel -j2 --tmpdir $temp graftM graft --forward $MFD/{}.fa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $WD/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $WD/log/{}.log

module load SciPy-bundle/2022.05-foss-2020b
python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_pmoA \
-n 0 -s '\t' -p combined_count_table $WD/graftm ConsensusLineage