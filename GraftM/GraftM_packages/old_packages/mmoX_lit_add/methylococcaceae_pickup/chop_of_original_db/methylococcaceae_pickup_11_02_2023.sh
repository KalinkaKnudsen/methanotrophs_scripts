#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/methylococcaceae_pickup/chop_of_original_db
cd $WD
seqs=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.faa

#### seqkit!
module load SeqKit/2.0.0

seqkit sliding $seqs --window 50 --step 5 --greedy > $WD/mmoX_seq_chop.faa

module purge
module load GraftM/0.14.0-foss-2020b

GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022
export TMPDIR=/user_data/kalinka/temp

graftM graft --forward $WD/mmoX_seq_chop.faa --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $WD/graftm/ --verbosity 5 \
 --threads 5 --force --input_sequence_type aminoacid --search_method hmmsearch+diamond --log $WD/graftm/chop.log

sort -t$'\t' -k1,1 $WD/graftm/mmoX_seq_chop/mmoX_seq_chop_read_tax.tsv > $WD/graftm/mmoX_seq_chop/mmoX_seq_chop_read_tax_sorted.tsv
grep "Root; likely_mmoX; Methylococcaceae_mmoX" $WD/graftm/mmoX_seq_chop/mmoX_seq_chop_read_tax_sorted.tsv \
> $WD/graftm/mmoX_seq_chop/mmoX_seq_chop_read_tax_sorted_methylococcaceae.tsv
### Now I want to combine the read tax file with the taxonomy of the seqeunces ###
### First I need to make this csv to a tsv file

sed 's/,/\t/g' /user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/graftM_mmoX_01_11_2022.refpkg/mmoX_sequences_seqinfo.csv \
| sort -t$'\t' -k1,1 > $WD/seq_info.tsv

sed 's/_sliding:.*Root/\tRoot/g' $WD/graftm/mmoX_seq_chop/mmoX_seq_chop_read_tax_sorted_methylococcaceae.tsv \
| sort -t$'\t' -k1,1 | uniq > $WD/methylococcaceae_hits.tsv

join -t $'\t' -1 1 -2 1 $WD/methylococcaceae_hits.tsv $WD/seq_info.tsv -o 1.1,1.2,2.2 > $WD/methylococcaceae_hits_matched.tsv



#### I want to count how many seqs are "rightly" and "wrongly" classified
sed 's/_sliding:.*Root/\tRoot/g' $WD/graftm/mmoX_seq_chop/mmoX_seq_chop_read_tax_sorted_methylococcaceae.tsv \
| sort -t$'\t' -k1,1 > $WD/methylococcaceae_hits_long.tsv

join -t $'\t' -1 1 -2 1 $WD/methylococcaceae_hits_long.tsv $WD/seq_info.tsv -o 1.1,1.2,2.2 > $WD/methylococcaceae_hits_matched_long.tsv

cut -f 2,3 $WD/methylococcaceae_hits_matched_long.tsv | sort | uniq -c | sort -rn > \
$WD/sum_of_methylococcaceae_hits.tsv


### Extracting the "Beijerinckiaceae_mmoX" hits

grep "Beijerinckiaceae_mmoX" $WD/methylococcaceae_hits_matched_long.tsv | cut -f 1 \
| grep -f - $WD/graftm/mmoX_seq_chop/mmoX_seq_chop_read_tax_sorted.tsv | grep "Methylococcaceae_mmoX" | \
cut -f 1 | grep -A1 -f - $WD/graftm/mmoX_seq_chop/mmoX_seq_chop_hits.aln.fa > $WD/Beijerinckiaceae_mmoX_alignment.aln.fa