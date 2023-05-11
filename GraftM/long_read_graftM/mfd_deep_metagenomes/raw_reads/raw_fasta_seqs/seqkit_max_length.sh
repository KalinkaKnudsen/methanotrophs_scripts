#!/bin/bash
module load SeqKit/2.0.0

cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064_sorted.fa | \
seqkit seq -M 100000 --remove-gaps -j 20 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064_less_100k.fa


cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138_sorted.fa | \
seqkit seq -M 100000 --remove-gaps -j 20 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138_less_100k.fa

