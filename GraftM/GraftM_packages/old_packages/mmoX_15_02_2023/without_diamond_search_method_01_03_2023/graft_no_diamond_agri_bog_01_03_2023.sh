#!/bin/bash

#set working directory
WD_old=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup
WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/without_diamond_search_method_01_03_2023
cd $WD
bog_odir=$WD/bog_samples
agri_odir=$WD/agri_samples


bog_list=/user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/bogs_seqid.txt
agri_list=$WD_old/unique_seqids.txt
shallow_metagenomes=/projects/microflora_danica/shallow_metagenomes


######### First I want to get the paths to  the files in the shallow-metagenomes folder #####

# Specify the parent folder

# Specify the list of filenames to search for
# Specify the output file for the list of matched files
#output_file="/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/without_diamond_search_method_01_03_2023/bog_list_temp.txt"

# Loop through all subdirectories within parent_folder and print path of bog samples
#while IFS= read -r -d '' sub_dir; do
#find "$sub_dir" -type f -name "*.gz" -path "*/sequences_trim/*" \
#    | grep -Ff "$bog_list" \
#    >> "$output_file"
#done < <(find "$shallow_metagenomes" -type d -print0)

#sort $output_file | uniq | grep -v "_R2_fastp.fastq.gz" > $WD/bog_path.txt
#rm $output_file

# Loop through all subdirectories within parent_folder and print path of agri samples
#while IFS= read -r -d '' sub_dir; do
#find "$sub_dir" -type f -name "*.gz" -path "*/sequences_trim/*" \
#    | grep -Ff "$agri_list" \
#    >> "$output_file"
#done < <(find "$shallow_metagenomes" -type d -print0)

#sort $output_file | uniq | grep -v "_R2_fastp.fastq.gz" > $WD/agri_path.txt
#rm $output_file


##### First thing is moving the samples to my directory ######

### Then I want to run graftM on the extracted samples 
# Set variables
mkdir -p $bog_odir/mmoX/graftm
ODIR_mmoX_bog=$bog_odir/mmoX/graftm
mkdir -p $bog_odir/mmoX/log

mkdir -p $agri_odir/mmoX/graftm
ODIR_mmoX_agri=$agri_odir/mmoX/graftm
mkdir -p $agri_odir/mmoX/log

THREADS=5
GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/GraftM_mmoX_package_15_02_2023

############################################
# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

# temporary folder for parallel
temp=/user_data/kalinka/temp

cat $WD/bog_path.txt | parallel -j8 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX_bog/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch '&>' $bog_odir/mmoX/log/{/.}.log

cat $WD/agri_path.txt | parallel -j8 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX_agri/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch '&>' $agri_odir/mmoX/log/{/.}.log


############ And then to pmoA #############

mkdir -p $bog_odir/pmoA/graftm
ODIR_pmoA_bog=$bog_odir/pmoA/graftm
mkdir -p $bog_odir/pmoA/log

mkdir -p $agri_odir/pmoA/graftm
ODIR_pmoA_agri=$agri_odir/pmoA/graftm
mkdir -p $agri_odir/pmoA/log

GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22

cat $WD/bog_path.txt | parallel -j8 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA_bog/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch '&>' $bog_odir/pmoA/log/{/.}.log

cat $WD/agri_path.txt | parallel -j8 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA_agri/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch '&>' $agri_odir/pmoA/log/{/.}.log



##Then combining the output
module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $bog_odir/combined_count_table_mmoX_bog \
-n 0 -s '\t' -p combined_count_table $ODIR_mmoX_bog ConsensusLineage
sed -i 's/_R1_fastp//g' $bog_odir/combined_count_table_mmoX_bog.txt

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $agri_odir/combined_count_table_mmoX_agri \
-n 0 -s '\t' -p combined_count_table $ODIR_mmoX_agri ConsensusLineage
sed -i 's/_R1_fastp//g' $agri_odir/combined_count_table_mmoX_agri.txt

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $bog_odir/combined_count_table_pmoA_bog \
-n 0 -s '\t' -p combined_count_table $ODIR_pmoA_bog ConsensusLineage
sed -i 's/_R1_fastp//g' $bog_odir/combined_count_table_pmoA_bog.txt

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $agri_odir/combined_count_table_pmoA_agri \
-n 0 -s '\t' -p combined_count_table $ODIR_pmoA_agri ConsensusLineage
sed -i 's/_R1_fastp//g' $agri_odir/combined_count_table_pmoA_agri.txt