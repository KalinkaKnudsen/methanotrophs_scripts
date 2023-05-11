#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD


module load MAFFT/7.490-GCC-10.2.0-with-extensions
###Combining the files

cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/combined_contigs_mmoX_cluster1.fa \
 /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/mmoX/combined_mmoX_raw.fa \
/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.faa \
 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/mmoX/combined_mmoX_raw_and_contigs.fa

cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/combined_contigs_pmoA_cluster1.fa \
 /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/pmoA/combined_pmoA_raw.fa \
/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.faa \
/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/uscg.faa \
 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/pmoA/combined_pmoA_raw_and_contigs.fa


mafft /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/pmoA/combined_pmoA_raw_and_contigs.fa\
 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/pmoA/combined_pmoA_raw_and_contigs_aligned.fa

mafft /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/mmoX/combined_mmoX_raw_and_contigs.fa \
 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/mmoX/combined_mmoX_raw_and_contigs_aligned.fa

module load TrimAl/1.4.1-foss-2020b
trimal -in /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/pmoA/combined_pmoA_raw_and_contigs_aligned.fa \
 -out /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/pmoA/combined_pmoA_raw_and_contigs_aligned_20perc2.fa -gt 0.2


trimal -in /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/mmoX/combined_mmoX_raw_and_contigs_aligned.fa \
 -out /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/mmoX/combined_mmoX_raw_and_contigs_aligned_20perc2.fa -gt 0.2

module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -redo -s /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/pmoA/combined_pmoA_raw_and_contigs_aligned_20perc2.fa -m MFP -nt AUTO -B 1000 -T AUTO
iqtree2 -redo -s /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/mmoX/combined_mmoX_raw_and_contigs_aligned_20perc2.fa -m MFP -nt AUTO -B 1000 -T AUTO