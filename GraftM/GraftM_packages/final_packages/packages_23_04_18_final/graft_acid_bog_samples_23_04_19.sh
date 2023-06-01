#!/bin/bash
#set working directory

WD=/user_data/kalinka/GraftM/GraftM_packages/packages_23_04_18
cd $WD

if [ -d "$WD/bog_test_23_04_18" ]; then
    echo "$WD folder exist, so skipping creation"
    else 
    mkdir -p $WD/bog_test_23_04_18
fi

odir=$WD/bog_test_23_04_18


if [ -d "$odir/pmoA_e10" ]; then
    echo "$odir/pmoA_e10 folder exist, so skipping creation"
    else 
    mkdir -p $odir/pmoA_e10
fi

if [ -d "$odir/mmoX_e10" ]; then
    echo "$odir/mmoX_e10 folder exist, so skipping creation"
    else 
    mkdir -p $odir/mmoX_e10
fi

shallow_metagenomes=/projects/microflora_danica/shallow_metagenomes
bog_path=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/bog_test_23_03_16/bog_path.txt
### Created in /user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/graft_acid_bog_samples_23_03_16.sh

# Set variables
mkdir -p $odir/pmoA_e10/graftm
mkdir -p $odir/pmoA_e10/log
mkdir -p $odir/mmoX_e10/graftm
mkdir -p $odir/mmoX_e10/log

THREADS=4
GRAFTM_PACKAGE_pmoA=$WD/pmoA_GraftM_23_04_18
GRAFTM_PACKAGE_mmoX=$WD/mmoX_GraftM_23_04_18

############################################
# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

# temporary folder for parallel
temp=/user_data/kalinka/temp

cat $bog_path | parallel -j3 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $odir/pmoA_e10/graftm/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch+diamond --evalue 1e-10 '&>' $odir/pmoA_e10/log/{/.}.log

cat $bog_path | parallel -j3 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $odir/mmoX_e10/graftm/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch+diamond --evalue 1e-10 '&>' $odir/mmoX_e10/log/{/.}.log


##Then combining the output
module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/join_files.py -e txt -f $odir/combined_count_table_pmoA_e10 \
-n 0 -s '\t' -p combined_count_table $odir/pmoA_e10/graftm ConsensusLineage
sed -i 's/_R1_fastp//g' $odir/combined_count_table_pmoA_e10.txt

python3 /user_data/kalinka/join_files.py -e txt -f $odir/combined_count_table_mmoX_e10 \
-n 0 -s '\t' -p combined_count_table $odir/mmoX_e10/graftm ConsensusLineage
sed -i 's/_R1_fastp//g' $odir/combined_count_table_mmoX_e10.txt




###### For the "standard" error 

if [ -d "$odir/pmoA_e5" ]; then
    echo "$odir/pmoA_e5 folder exist, so skipping creation"
    else 
    mkdir -p $odir/pmoA_e5
fi

if [ -d "$odir/mmoX_e5" ]; then
    echo "$odir/mmoX_e5 folder exist, so skipping creation"
    else 
    mkdir -p $odir/mmoX_e5
fi

mkdir -p $odir/pmoA_e5/graftm
mkdir -p $odir/pmoA_e5/log
mkdir -p $odir/mmoX_e5/graftm
mkdir -p $odir/mmoX_e5/log

module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

cat $bog_path | parallel -j3 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $odir/pmoA_e5/graftm/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch+diamond '&>' $odir/pmoA_e5/log/{/.}.log

cat $bog_path | parallel -j3 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $odir/mmoX_e5/graftm/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch+diamond '&>' $odir/mmoX_e5/log/{/.}.log


##Then combining the output
module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/join_files.py -e txt -f $odir/combined_count_table_pmoA_e5 \
-n 0 -s '\t' -p combined_count_table $odir/pmoA_e5/graftm ConsensusLineage
sed -i 's/_R1_fastp//g' $odir/combined_count_table_pmoA_e5.txt

python3 /user_data/kalinka/join_files.py -e txt -f $odir/combined_count_table_mmoX_e5 \
-n 0 -s '\t' -p combined_count_table $odir/mmoX_e5/graftm ConsensusLineage
sed -i 's/_R1_fastp//g' $odir/combined_count_table_mmoX_e5.txt
