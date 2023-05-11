#!/bin/bash
module load SeqKit/2.0.0

seqkit sort -l -j 20 -o /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138_sorted.fa \
/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138.fasta

seqkit stats -j 20 -o /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138_stats.txt \
/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138.fasta

seqkit sort -l -j 20 -o /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064_sorted.fa \
/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064.fasta

seqkit stats -j 20 -o /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064_stats.txt \
/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064.fasta



cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064_sorted.fa | \
seqkit seq -m 1000000 --remove-gaps > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064_sorted_1mil.fa


cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138_sorted.fa | \
seqkit seq -m 1000000 --remove-gaps > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138_sorted_1mil.fa