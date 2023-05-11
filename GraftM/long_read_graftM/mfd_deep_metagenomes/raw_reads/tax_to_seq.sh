#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD

sed -i 's/runid.*//g' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/mmoX/combined_long_sequences_deduplicated.fa

sed -i 's/runid.*//g' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/pmoA/combined_long_sequences_deduplicated.fa




awk -F'\t' '{print $2" ,"$1}' $WD/mmoX/combined_deduplicated_blast_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1,[/;s/\].*$/\]/' | sed 's/^/MFD_contig_/' | sed 's/ ,/,/'> $WD/mmoX/tax_file_mmoX.csv

cat $WD/mmoX/tax_file_mmoX.txt | grep -v "Actino*" > $WD/mmoX/tax_file_reduced_mmoX.txt


awk -F'\t' '{print $2" ,"$1}' $WD/pmoA/combined_deduplicated_blast_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1,[/;s/\].*$/\]/' | sed 's/^/MFD_contig_/' | sed 's/ ,/,/'> $WD/pmoA/tax_file_pmoA.csv


cat $WD/pmoA/combined_long_sequences_deduplicated.fa \
| awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' \
| sed 's/>/>MFD_contig_/' > $WD/pmoA/pmoA_MFD_contigs.faa

cat $WD/mmoX/combined_long_sequences_deduplicated.fa \
| awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' \
| sed 's/>/>MFD_contig_/' > $WD/mmoX/mmoX_MFD_contigs.faa


####I want to have all the sequences, and just dedpulicate them at 100% #######
usearch -cluster_fast $WD/pmoA/combined_long_sequences.fa \
-id 1 -centroids $WD/pmoA/pmoA_seqs_id1.fa

usearch -cluster_fast $WD/mmoX/combined_long_sequences.fa \
-id 1 -centroids $WD/mmoX/mmoX_seqs_id1.fa



sed -i 's/runid.*//g' $WD/mmoX/mmoX_seqs_id1.fa

sed -i 's/runid.*//g' $WD/pmoA/pmoA_seqs_id1.fa


awk -F'\t' '{print $2" ,"$1}' $WD/mmoX/combined_deduplicated_blast_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1[/;s/\].*$/\]/' | sed 's/^/MFD_contig_/'> $WD/mmoX/tax_file_mmoX.txt

#cat $WD/mmoX/tax_file_mmoX.txt | grep -v "Actino*" > $WD/mmoX/tax_file_reduced_mmoX.txt


awk -F'\t' '{print $2" ,"$1}' $WD/pmoA/combined_deduplicated_blast_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1[/;s/\].*$/\]/' | sed 's/^/MFD_contig_/'> $WD/pmoA/tax_file_pmoA.txt


cat $WD/pmoA/pmoA_seqs_id1.fa \
| awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' \
| sed 's/>/>MFD_contig_/' > $WD/pmoA/pmoA_MFD_contigs.faa

cat $WD/mmoX/mmoX_seqs_id1.fa \
| awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' \
| sed 's/>/>MFD_contig_/' > $WD/mmoX/mmoX_MFD_contigs.faa


pmoA_sequences=/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.faa
mmoX_sequences=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.faa
#First, I need to append the files together. I do not know yet if I want to do this per-sample basis or just in 1 go... Perhaps just 1 go!

cat $pmoA_sequences $WD/pmoA/pmoA_MFD_contigs.faa > $WD/pmoA/pmoA_graft_raw_combined.faa
cat $mmoX_sequences $WD/mmoX/mmoX_MFD_contigs.faa > $WD/mmoX/mmoX_graft_raw_combined.faa


#Now I want to cluster this to the graftM sequences;

usearch -cluster_fast $WD/pmoA/pmoA_graft_raw_combined.faa \
-id 1 -centroids $WD/pmoA/graft_raw_combined_deduplicated.faa

usearch -cluster_fast $WD/mmoX/mmoX_graft_raw_combined.faa \
-id 1 -centroids $WD/mmoX/graft_raw_combined_deduplicated.faa


##To find the sequences that were removed

diff $WD/mmoX/graft_raw_combined.faa $WD/mmoX/graft_raw_combined_deduplicated.faa | grep '^> >' > $WD/mmoX/seq_removed.faa
diff $WD/pmoA/graft_raw_combined.faa $WD/pmoA/graft_raw_combined_deduplicated.faa | grep '^> >' > $WD/pmoA/seq_removed.faa