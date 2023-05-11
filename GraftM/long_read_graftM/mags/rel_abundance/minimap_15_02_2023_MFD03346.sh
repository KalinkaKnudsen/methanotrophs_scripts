#!/bin/bash

WD=/user_data/kalinka/GraftM/long_read_graftM/mags/rel_abundance
cd $WD

assembly=/projects/microflora_danica/deep_metagenomes/assemblies/MFD03346.fasta
reads=/projects/microflora_danica/deep_metagenomes/reads/MFD03346_R1041_trim_filt.fastq
mag=/projects/microflora_danica/deep_metagenomes/mags_v1/mags/MFD03346_bin.0050.fa

module purge
#module load minimap2/2.24-GCCcore-10.2.0


minimap2 -I 50G -K 10G -t 10 -ax map-ont $assembly $reads > $WD/temp1.sam
samtools view -Sb -F 2308 -@ 10 $WD/temp1.sam > $WD/temp1.bam
samtools sort $WD/temp1.bam -o $WD/MFD03346.bam -@ 5 -m 10G ### This line is run not in a screen on mobaX

module purge
module load CoverM/0.6.0-foss-2020b

coverm genome --bam-files $WD/MFD03346.bam --genome-fasta-files $mag \
-m mean -o $WD/MFD03346_cov_long.tsv -t 10

coverm genome --bam-files $WD/MFD03346.bam --genome-fasta-files $mag \
-m relative_abundance -o $WD/MFD03346_abund_long.tsv -t 10
