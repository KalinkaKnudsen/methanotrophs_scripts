#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/proovframe/correcting_MFD01138_MFD10064
cd $WD

########## variables to set ################

THREADS=10

############################################

# load modules
module purge
module load OrfM/0.7.1-foss-2020b

temp=/user_data/kalinka/temp

export TMPDIR=/user_data/kalinka/temp
###############Creating seach file ########################
for line in $(cat $WD/searchfile.txt); do orfm -l 1000 $WD/"$line".fa \
> $WD/"$line"_CDS.fa; done

 module purge