#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD


module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $WD/pmoA/pmoA_graft_raw_combined.faa > $WD/pmoA/pmoA_graft_raw_combined_aligned.faa
mafft $WD/mmoX/mmoX_graft_raw_combined.faa > $WD/mmoX/mmoX_graft_raw_combined_aligned.faa

module load TrimAl/1.4.1-foss-2020b
trimal -in $WD/pmoA/pmoA_graft_raw_combined_aligned.faa -out $WD/pmoA/pmoA_graft_raw_combined_20perc2.fa -gt 0.2
trimal -in $WD/mmoX/mmoX_graft_raw_combined_aligned.faa -out $WD/mmoX/mmoX_graft_raw_combined_20perc2.fa -gt 0.2

module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $WD/pmoA/pmoA_graft_raw_combined_20perc2.fa -m MFP -nt AUTO -B 1000 -T AUTO
iqtree2 -s $WD/mmoX/mmoX_graft_raw_combined_20perc2.fa -m MFP -nt AUTO -B 1000 -T AUTO