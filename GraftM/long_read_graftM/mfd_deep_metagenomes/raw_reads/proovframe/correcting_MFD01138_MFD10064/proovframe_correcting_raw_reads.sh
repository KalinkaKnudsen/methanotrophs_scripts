#!/bin/bash
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD

MFD_raw=/projects/microflora_danica/deep_metagenomes/reads
ODIR=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/proovframe/correcting_MFD01138_MFD10064

mkdir -p $ODIR/pmoA
mkdir -p $ODIR/mmoX

for line in $(cat $ODIR/searchfile.txt); do cat $MFD_raw/"$line"_R1041_trim_filt.fastq \
| awk '{if(NR%4==1) {printf(">%s\n",substr($0,2));} else if(NR%4==2) print;}' > $ODIR/"$line".fa; done

module purge
module load DIAMOND/2.0.9-foss-2020b

####First I need to make tsv files for all the samples both pmoA and mmoX
for line in $(cat $ODIR/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t 30 -d \
/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.dmnd \
-o $ODIR/pmoA/"$line".tsv $ODIR/"$line".fa -- -c1; done

for line in $(cat $ODIR/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t 30 -d \
/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.dmnd \
-o $ODIR/mmoX/"$line".tsv $ODIR/"$line".fa -- -c1; done

##Then, I will edit the sequences
for line in $(cat $ODIR/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
-o $ODIR/pmoA/"$line"_corrected.fa $ODIR/"$line".fa \
$ODIR/pmoA/"$line".tsv; done

for line in $(cat $ODIR/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
-o $ODIR/mmoX/"$line"_corrected.fa $ODIR/"$line".fa \
$ODIR/mmoX/"$line".tsv; done