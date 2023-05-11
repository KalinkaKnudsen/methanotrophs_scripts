#!/bin/bash

WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD

module purge
module load DIAMOND/2.0.9-foss-2020b

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD/mmoX/combined_long_sequences_deduplicated.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD/mmoX/combined_deduplicated_blast_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 80

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD/pmoA/combined_long_sequences_deduplicated.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD/pmoA/combined_deduplicated_blast_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 80
module purge



grep -o '\[[^][]*\]' $WD/mmoX/combined_deduplicated_blast_hits.txt | sort | uniq -c > $WD/mmoX/mmoX_blast_hit_species.txt
grep -o '\[[^][]*\]' $WD/pmoA/combined_deduplicated_blast_hits.txt | sort | uniq -c > $WD/pmoA/pmoA_blast_hit_species.txt


sed -i 's/runid.*//g' $WD/mmoX/combined_long_sequences_deduplicated.fa

sed -i 's/runid.*//g' $WD/pmoA/combined_long_sequences_deduplicated.fa




awk -F'\t' '{print $2" ,"$1}' $WD/mmoX/combined_deduplicated_blast_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1[/;s/\].*$/\]/' > $WD/mmoX/tax_file_mmoX.txt


awk -F'\t' '{print $2" ,"$1}' $WD/pmoA/combined_deduplicated_blast_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1[/;s/\].*$/\]/' > $WD/pmoA/tax_file_pmoA.txt