#!/bin/bash

module load SciPy-bundle/2022.05-foss-2020b
WD=/user_data/kalinka/GraftM/shallow_21_12_2022

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_mmoX \
-n 0 -s '\t' -p combined_count_table $WD/mmoX/graftm ConsensusLineage

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $WD/combined_count_table_pmoA \
-n 0 -s '\t' -p combined_count_table $WD/pmoA/graftm ConsensusLineage


sed -i 's/_R1_fastp//g' $WD/combined_count_table_mmoX.txt
sed -i 's/_R1_fastp//g' $WD/combined_count_table_pmoA.txt