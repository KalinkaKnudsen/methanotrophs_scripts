#!/bin/bash

WD=/user_data/kalinka/GraftM/long_read_graftM/mags/rel_abundance
cd $WD

assembly=/projects/microflora_danica/deep_metagenomes/assemblies/MFD03399.fasta
reads=/projects/microflora_danica/deep_metagenomes/reads/MFD03399_R1041_trim_filt.fastq

module purge
module load minimap2/2.24-GCCcore-10.2.0


minimap2 -I 50G -K 10G -t 20 -ax map-ont $assembly $reads > $WD/temp1.sam
samtools view -Sb -F 2308 --threads 20 $WD/temp1.sam > $WD/temp1.bam
samtools sort --threads 20 $WD/temp1.bam -o $WD/MFD03399.bam

#minimap2 -I 50G -K 10G -t 20 -ax map-ont $assembly $reads | samtools view -Sb -F 2308 - | samtools sort - > $WD/MFD03399_2.bam

module purge
module load CoverM/0.6.0-foss-2020b

coverm genome --bam-files $WD/MFD03399.bam --genome-fasta-files /projects/microflora_danica/deep_metagenomes/mags_v1/mags/MFD03399_bin.c2.fa \
-m mean -o $WD/MFD03399_cov_long.tsv -t 20

coverm genome --bam-files $WD/MFD03399.bam --genome-fasta-files /projects/microflora_danica/deep_metagenomes/mags_v1/mags/MFD03399_bin.c2.fa \
-m relative_abundance -o $WD/MFD03399_abund_long.tsv -t 20
