#!/bin/bash
#set working directory

WD=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA
cd $WD
mkdir $WD/bog_test_23_03_16
odir=$WD/bog_test_23_03_16

bog_list=/user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/bogs_seqid.txt
shallow_metagenomes=/projects/microflora_danica/shallow_metagenomes


######### First I want to get the paths to  the files in the shallow-metagenomes folder #####

# Specify the parent folder

# Specify the list of filenames to search for
# Specify the output file for the list of matched files
output_file="$odir/bog_list_temp.txt"

# Loop through all subdirectories within parent_folder and print path of bog samples
while IFS= read -r -d '' sub_dir; do
find "$sub_dir" -type f -name "*.gz" -path "*/sequences_trim/*" \
    | grep -Ff "$bog_list" \
    >> "$output_file"
done < <(find "$shallow_metagenomes" -type d -print0)

sort $output_file | uniq | grep -v "_R2_fastp.fastq.gz" > $odir/bog_path.txt
rm $output_file

### Then I want to run graftM on the extracted samples 
# Set variables
mkdir -p $odir/graftm
mkdir -p $odir/log

THREADS=5
GRAFTM_PACKAGE_pmoA=$WD/pmoA_package_23_03_16

############################################
# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel

# temporary folder for parallel
temp=/user_data/kalinka/temp

cat $odir/bog_path.txt | parallel -j4 --tmpdir $temp graftM graft --forward {} \
--graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $odir/graftm/{/.} \
--verbosity 5 --threads $THREADS --force --input_sequence_type nucleotide \
--search_method hmmsearch+diamond '&>' $odir/log/{/.}.log


##Then combining the output
module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $odir/combined_count_table_pmoA_bog \
-n 0 -s '\t' -p combined_count_table $odir/graftm ConsensusLineage
sed -i 's/_R1_fastp//g' $odir/combined_count_table_pmoA_bog.txt
