#!/bin/bash
############Okay prodigal has to run on fasta and not fastq files! This might explain a lot.... So, I will have to rerun prodigal once the fasta files are created!
module purge
module load prodigal/2.6.3-foss-2020b


prodigal -c -d /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138_prodigal.fasta -m -i /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD01138.fasta
prodigal -c -d /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064_prodigal.fasta -m -i /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs/MFD10064.fasta

module purge