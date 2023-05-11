#!/bin/bash
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD

ODIR=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/proovframe/correcting_MFD01138_MFD10064

module purge
module load DIAMOND/2.0.9-foss-2020b

####First I need to make tsv files for all the two samples. But I only use 1 db, so I only need to do this once. 
for line in $(cat $ODIR/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t 80 -d \
/user_data/kalinka/nr.dmnd \
-o $ODIR/nr_correction/"$line".tsv $ODIR/"$line".fa -- -c1; done

##Then, I will edit the sequences
for line in $(cat $ODIR/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix -t 80\
-o $ODIR/nr_correction/"$line"_corrected.fa $ODIR/"$line".fa \
$ODIR/nr_correction/"$line".tsv; done

module purge