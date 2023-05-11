#!/bin/bash

WD=/user_data/kalinka/selected_3_samples_23_03_18/sequencing_statistics
THREADS=10
seqs=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/seqs_less_500k
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt
cd $WD

temp=/user_data/kalinka/temp
export TMPDIR=/user_data/kalinka/temp

# If output folder does not already exists, make it
if [ -d "$WD" ]; then
    echo "$WD folder exist, so skipping creation"
    else 
    mkdir -p $ODIR
fi

# load modules
module load NanoPlot/1.40.2-foss-2020b
module load parallel

 # Run stats with NanoPlot

cat $searchfile | parallel -j3 --tmpdir $temp  NanoPlot --fastq $seqs/{}.fastq \
 -t $THREADS --tsv_stats --drop_outliers --N50 -o $WD/{}