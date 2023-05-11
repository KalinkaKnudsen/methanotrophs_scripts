#!/bin/bash
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD


####Now I need to extract the lines from the HMM-out, that match the reads of the tax_filtered file
for line in $(cat $WD/searchfile.txt); do grep ">" $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_orf_long.aln.fa \
| awk -F'[_ ]' '{print $1}'  | sort | uniq >> $WD/pmoA/combined_pmoA_orf_long_16_01_23.aln.fa \
| echo $line; done

for line in $(cat $WD/searchfile.txt); do grep ">" $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_orf_long.aln.fa \
| awk -F'[_ ]' '{print $1}' | sort | uniq >> $WD/mmoX/combined_mmoX_orf_long_16_01_23.aln.fa \
| echo $line; done

##Then to the number of reads after the correction

for line in $(cat $WD/searchfile.txt); do grep ">" $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_deduplicated_long_sequences.fa \
| awk -F'[_ ]' '{print $1}'  | sort | uniq >> $WD/pmoA/combined_with_corrected_pmoA_orf_long_16_01_23.aln.fa \
| echo $line; done

for line in $(cat $WD/searchfile.txt); do grep ">" $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_deduplicated_long_sequences.fa \
| awk -F'[_ ]' '{print $1}' | sort | uniq >> $WD/mmoX/combined_with_corrected_mmoX_orf_long_16_01_23.aln.fa \
| echo $line; done


###And counting the original short reads failing####
/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/mmoX/graftm/MFD01223/MFD01223_R1041_trim_filt/MFD01223_alignment_shorter_400.aln.fa

for line in $(cat $WD/searchfile.txt); do grep ">" $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_alignment_shorter_200.aln.fa \
| awk -F'[_ ]' '{print $1}'  | sort | uniq >> $WD/pmoA/combined_short_sequences_16_01_23.aln.fa \
| echo $line; done

for line in $(cat $WD/searchfile.txt); do grep ">" $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_alignment_shorter_400.aln.fa \
| awk -F'[_ ]' '{print $1}' | sort | uniq >> $WD/mmoX/combined_short_sequences_16_01_23.aln.fa \
| echo $line; done