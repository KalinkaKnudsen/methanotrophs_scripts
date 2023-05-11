#!/bin/bash

# Specify the parent folder
parent_folder="/projects/microflora_danica/shallow_metagenomes"

# Specify the list of filenames to search for
filename_list="/user_data/kalinka/GraftM/GraftM_packages/placement_bogs_16_02_2023/bogs_seqid.txt"

# Specify the output file for the list of matched files
output_file="/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/without_diamond_search_method_01_03_2023/bog_list_emil.txt"

# Loop through all subdirectories within parent_folder
while IFS= read -r -d '' sub_dir; do
find "$sub_dir" -type f -name "*.gz" -path "*/sequences_trim/*" \
    | grep -Ff "$filename_list" \
    >> "$output_file"
done < <(find "$parent_folder" -type d -print0)

sort $output_file | uniq | grep -v "_R2_fastp.fastq.gz" > bog_path.txt
rm $output_file

