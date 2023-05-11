#!/bin/bash

WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/diamond_frameshift
cd $WD

module purge
module load DIAMOND/2.0.9-foss-2020b

#--frameshift/-F 

#Penalty for frameshifts in DNA-vs-protein alignments. Values around 15 are reasonable for this parameter. Enabling this feature will have the aligner tolerate missing bases in DNA sequences and is most recommended for long, error-prone sequences like MinION reads.
#In the pairwise output format, frameshifts will be indicated by \ and / for a shift by +1 and -1 nucleotide in the direction of translation respectively. Note that this feature is disabled by default.

#

##I select sample MFD01223 /projects/microflora_danica/deep_metagenomes/reads/MFD01223_R1041_trim_filt.fastq
# The "*" character in the qseq_translated field of the output from DIAMOND blastx indicates that a gap was introduced in the translation due to the frameshift-aware alignment option.

diamond blastx --db /user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.dmnd \
--frameshift 15 --verbose --threads 10 -b12 -c1 --max-target-seqs 1 -f 6 qseqid sseqid sstart send length slen \
qstart qend qlen qframe evalue bitscore nident pident mismatch qseq_translated qseq \
--query /projects/microflora_danica/deep_metagenomes/reads/MFD01248_R1041_trim_filt.fastq \
-o $WD/MFD01248_frame_diamond_20_01_2023.txt --tmpdir  /user_data/kalinka/temp


diamond blastx --db /user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.dmnd \
--frameshift 15 --verbose --threads 10 -b12 -c1 -f 0 --max-target-seqs 1 --unal 0 \
--query /projects/microflora_danica/deep_metagenomes/reads/MFD01223_R1041_trim_filt.fastq \
-o $WD/MFD01223_frame_diamond_20_01_2023.txt --tmpdir  /user_data/kalinka/temp


###Then I want to make a filter that works like what I am doing in the HMM. I do not want to filter in the blastx, because I want to be able to trace back!
####But i could probably do in by working with the blast filters/options ####

#I need to filter at columns "length" witch is col 5. That is the length of the alignment. Perhaps I set this to 200? Or even 220?

awk '{ if ($5 > 210) {print $0}}'  $WD/MFD01248_frame_diamond_20_01_2023.txt \
> $WD/MFD01248_frame_diamond_20_01_2023_filter_210.txt

awk '{ if ($5 > 200) {print $0}}'  $WD/MFD01248_frame_diamond_20_01_2023.txt \
> $WD/MFD01248_frame_diamond_20_01_2023_filter_200.txt