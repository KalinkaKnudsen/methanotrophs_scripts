#!/bin/bash
module load SeqKit/2.0.0
MFD_raw=/projects/microflora_danica/deep_metagenomes/reads

WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/raw_fasta_seqs
cd $WD


start=$(date +%s)

cat $MFD_raw/MFD01223_R1041_trim_filt.fastq | \
seqkit seq -M 100000 --remove-gaps > $WD/MFD01223_less_100k.fa

end=$(date +%s)
elapsed=$((end - start))
echo "MFD01223_less_100k Time elapsed: $elapsed seconds"

start=$(date +%s)
cat $MFD_raw/MFD01223_R1041_trim_filt.fastq | \
seqkit seq -M 500000 --remove-gaps > $WD/MFD01223_less_500k.fa

end=$(date +%s)
elapsed=$((end - start))
echo "MFD01223_less_500k Time elapsed: $elapsed seconds"

seqkit stats -o $WD/MFD01223_stats.txt $MFD_raw/MFD01223_R1041_trim_filt.fastq

seqkit stats -o $WD/MFD01223_less_100k_stats.txt $WD/MFD01223_less_100k.fa

seqkit stats -o $WD/MFD01223_less_500k_stats.txt $WD/MFD01223_less_100k.fa