#!/bin/bash
WD=/user_data/kalinka/GraftM/long_read_graftM/mags
cd $WD

grep "^>MFD_contig_" /user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/contig_original_pmoA.fa | sed 's/^>MFD_contig_/>contig_/' > ./contigs_added_pmoA.txt

#I have done the filtering of the MAGS with hits in R. That was faster


#Now I want to copy all files from the searchfile into another file. So I want to get all the _orf.fa files
sed -i 's/\r$//' $WD/selected_bins_pmoA.txt ##Because my files from R have weird windows endings

for line in $(cat $WD/selected_bins_pmoA.txt); do
    cp $WD/pmoA/graftm/"$line"/"$line"/"$line"_orf.fa $WD/pmoA_contig_hits/ \
     | echo $line; done


#Now, I want to match the reads from my added contig file to the reads in the orf.fa files

for line in $(cat $WD/selected_bins_pmoA.txt); do
    grep -A1 -w -f $WD/contigs_added_pmoA.txt $WD/pmoA_contig_hits/"$line"_orf.fa\
    | sed 's/--//g' | sed '/^$/d' \
    > $WD/pmoA_contig_hits/extracted_hits/"$line".fa | echo $line; done


##I need to remove the files with no lines (two files)
find $WD/pmoA_contig_hits/extracted_hits -type f -empty -print -delete


#Then I want to combine the sequneces to one file and then cluster them;

for line in $(cat $WD/selected_bins_pmoA.txt); do
    grep -A1 -w -f $WD/contigs_added_pmoA.txt $WD/pmoA_contig_hits/"$line"_orf.fa\
    | sed 's/--//g' | sed '/^$/d' \
    >> $WD/combined_pmoA_binned_contigs.fa | echo $line; done

cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/combined_contigs_pmoA_cluster1.fa \
>> $WD/combined_pmoA_binned_contigs.fa

#And now I want to cluster them
usearch -cluster_fast $WD/combined_pmoA_binned_contigs.fa -id 1 -centroids $WD/combined_pmoA_binned_contigs_cluster1.fa




###Now I want to combine the bins to the contigs


ls /user_data/kalinka/GraftM/long_read_graftM/mags/pmoA_contig_hits/extracted_hits \
 | sed 's/.fa//g' > /user_data/kalinka/GraftM/long_read_graftM/mags/pmoA_contig_hits/temp1.txt

for line in $(cat $WD/pmoA_contig_hits/temp1.txt); do
    awk '{print $0 "," FILENAME}' $WD/pmoA_contig_hits/extracted_hits/"$line".fa \
    | grep ">" | sed 's|/user_data/kalinka/GraftM/long_read_graftM/mags/pmoA_contig_hits/extracted_hits/||g' \
    | sed 's/.fa$//' | sed 's/>//' >> $WD/pmoA_full_length_sequences_from_bins_19_01_2023.csv | echo $line; done

##Adding the graftM assignment###
for line in $(cat $WD/pmoA_contig_hits/temp1.txt); do
    awk -F "\t" '{print $1 "," $2}' $WD/pmoA/graftm/"$line"/"$line"/"$line"_read_tax.tsv \
  >> $WD/pmoA_contig_tax_19_01_2023.csv | echo $line; done



  for line in $(cat $WD/pmoA_contig_hits/temp1.txt); do
    awk -F "\t" '{print $1 "," $2}' $WD/pmoA/graftm/"$line"/"$line"/"$line"_read_tax.tsv \
  >> $WD/pmoA_contig_tax_19_01_2023.csv | echo $line; done


sort -t, -k1 $WD/pmoA_full_length_sequences_from_bins_19_01_2023.csv > $WD/pmoA_full_length_sequences_from_bins_19_01_2023_sorted.csv
sort -t, -k1 $WD/pmoA_contig_tax_19_01_2023.csv > $WD/pmoA_contig_tax_19_01_2023_sorted.csv

join -t, -1 1 -2 1 -o 1.1,1.2,2.2 $WD/pmoA_full_length_sequences_from_bins_19_01_2023_sorted.csv \
$WD/pmoA_contig_tax_19_01_2023_sorted.csv \
 > $WD/pmoA_full_length_sequences_from_bins_with_tax_19_01_2023.csv

sort -t, -k2 $WD/pmoA_full_length_sequences_from_bins_with_tax_19_01_2023.csv > $WD/pmoA_protein_from_bins_with_tax_19_01_2023.csv





 ##Getting the gtdb taxonomy
 head -n 1 /projects/microflora_danica/deep_metagenomes/mags_v1/gtdbtk.bac120.summary.tsv > \
 /user_data/kalinka/GraftM/long_read_graftM/mags/gtdb_selected_bins_pmoA.tsv

grep -f /user_data/kalinka/GraftM/long_read_graftM/mags/selected_bins_pmoA.txt \
/projects/microflora_danica/deep_metagenomes/mags_v1/gtdbtk.bac120.summary.tsv >> \
 /user_data/kalinka/GraftM/long_read_graftM/mags/gtdb_selected_bins_pmoA.tsv




##And merging the second column of this to the bin and graftM output ##


#Converting to csv;
tail -n +2 /user_data/kalinka/GraftM/long_read_graftM/mags/gtdb_selected_bins_pmoA.tsv | \
awk -F'\t' -v OFS=',' '{$1=$1} 1'  \
 > /user_data/kalinka/GraftM/long_read_graftM/mags/gtdb_selected_bins_pmoA.csv



join -t, -1 2 -2 1 -o 1.1,1.2,1.3,2.2 $WD/pmoA_protein_from_bins_with_tax_19_01_2023.csv \
/user_data/kalinka/GraftM/long_read_graftM/mags/gtdb_selected_bins_pmoA.csv \
 > $WD/pmoA_full_length_protein_gtdb.csv


sed -i 's/contig_/MFD_contig_/' $WD/pmoA_full_length_protein_gtdb.csv



##### This is not working ####

join -t, -1 2 -2 1 <(awk -F, '{print $1 "," $2 "," $3 "," $0}' $WD/pmoA_protein_from_bins_with_tax_19_01_2023.csv) \
 <(awk -F\t '{print $2 "," $0}' /user_data/kalinka/GraftM/long_read_graftM/mags/gtdb_selected_bins_pmoA.tsv) > /user_data/kalinka/GraftM/long_read_graftM/mags/gtdb_selected_bins_pmoA2.tsv





for line in $(cat $WD/pmoA_contig_hits/temp1.txt); do
    awk -F "_" '{print $1"_"$2 "," FILENAME}' $WD/pmoA_contig_hits/extracted_hits/"$line".fa \
    | grep ">" | sed 's|/user_data/kalinka/GraftM/long_read_graftM/mags/pmoA_contig_hits/extracted_hits/||g' \
    | sed 's/.fa$//' | sed 's/>//' >> $WD/pmoA_full_length_contigs_from_bins_19_01_2023.csv | echo $line; done

sort -t, -k1 $WD/pmoA_full_length_contigs_from_bins_19_01_2023.csv > $WD/pmoA_full_length_contigs_from_bins_19_01_2023_sorted.csv


sed 's/^\(contig_[0-9]*\)_.*,/\1,/' $WD/pmoA_full_length_sequences_from_bins_with_tax_19_01_2023.csv \
> $WD/pmoA_contig_tax_19_01_2023_2.csv

sort -t, -k1 $WD/pmoA_contig_tax_19_01_2023_2.csv > $WD/pmoA_contig_tax_19_01_2023_2_sorted.csv


join -t, -1 1 -2 1 -o 1.1,1.2,2.2 $WD/pmoA_full_length_contigs_from_bins_19_01_2023_sorted.csv \
$WD/pmoA_contig_tax_19_01_2023_2_sorted.csv \
 > $WD/pmoA_contigs_from_bins_with_tax_19_01_2023.csv

