#!/bin/bash
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD


MFD_raw=/projects/microflora_danica/deep_metagenomes/reads
FASTA_seqs=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs

mkdir -p $WD/proovframe/pmoA
mkdir -p $WD/proovframe/mmoX


##First I need to make the files from fastq to fasta;
temp=/user_data/kalinka/temp

export TMPDIR=/user_data/kalinka/temp


for line in $(cat $WD/searchfile.txt); do /user_data/kalinka/seqtk/seqtk seq -a $MFD_raw/"$line"_R1041_trim_filt.fastq > $FASTA_seqs/"$line".fa; done

module purge
module load DIAMOND/2.0.9-foss-2020b
####First I need to make tsv files for all the samples
for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t 80 -d \
/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.dmnd \
-o $WD/proovframe/pmoA/"$line".tsv $FASTA_seqs/"$line".fa -- -c1; done

for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t 80 -d \
/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.dmnd \
-o $WD/proovframe/mmoX/"$line".tsv $FASTA_seqs/"$line".fa -- -c1; done

##Then, I will edit the sequences
for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
-o $WD/proovframe/pmoA/"$line"_corrected.fa $FASTA_seqs/"$line".fa \
$WD/proovframe/pmoA/"$line".tsv; done

for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
-o $WD/proovframe/mmoX/"$line"_corrected.fa $FASTA_seqs/"$line".fa \
$WD/proovframe/mmoX/"$line".tsv; done
