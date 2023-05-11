#!/bin/bash

WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/combined_trees_contigs_raw/tree_for_LC/pmoA
cd $WD
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt
raw_reads=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads
no_filter=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift/no_filter/pmoA


#First, the HMM output file needs to be sorted and the HMM position needs to be extracted 
for line in $(cat $searchfile); do
  grep -v "#" $raw_reads/pmoA/graftm/$line/"$line"/"$line".hmmout.txt \
  | tr -s ' ' | awk -F' ' -v OFS='\t' "{print \"$line\", \"raw\", \$1, \$16, \$17, \$3}" \
> $WD/"$line"_hmm_hit_file_pmoA.tsv ; done

## Then sorting this file based on the read_ID
for line in $(cat $searchfile); do
    sort -k2 $WD/"$line"_hmm_hit_file_pmoA.tsv > $WD/"$line"_hmm_hit_file_sorted_pmoA.tsv
done

##Sorting the tax file
for line in $(cat $searchfile); do
    sort -k1 $raw_reads/pmoA/graftm/$line/"$line"/"$line"_read_tax.tsv > $WD/"$line"_read_tax_sorted.tsv
done

### Joining and printing header below. Since I join by the tax file, the high E-value reads should be removed, as they are not reported to the read_tax file ###
for line in $(cat $searchfile); do
(join -t $'\t' -1 1 -2 3 -o '2.1 2.2 1.1 1.2 2.4 2.5 2.6' $WD/"$line"_read_tax_sorted.tsv $WD/"$line"_hmm_hit_file_sorted_pmoA.tsv \
 | awk -v OFS='\t' 'BEGIN{print "Sample\tRead\tSequence\tTax\thmm_start\thmm_end\tLength"} {print $0}') \
> $WD/"$line"_position_of_pmoA_hits.tsv
done

### Removing all files but the position of hits file ###
for line in $(cat $searchfile); do
rm -r $WD/"$line"_read_tax_sorted.tsv $WD/"$line"_hmm_hit_file_sorted_pmoA.tsv $WD/"$line"_hmm_hit_file_pmoA.tsv
done



######### Now I need to do the same for the corrected reads! ######
module purge
module load HMMER/3.3.2-foss-2020b

mkdir $WD/HMM_corrected
pmoA_tax=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift/pmoA/IQtree/pmoA_package_tax.csv

output_path=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift/no_filter

#Doing HMM-scan;
for line in $(cat $searchfile); do hmmsearch --domtblout \
$WD/HMM_corrected/"$line"_hmmout.txt \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/pmoA_align_20.hmm \
$output_path/pmoA/"$line"_sequences.fa; done


#First, the HMM output file needs to be sorted and the HMM position needs to be extracted 
for line in $(cat $searchfile); do
  grep -v "#" $WD/HMM_corrected/"$line"_hmmout.txt \
  | tr -s ' ' | awk -F' ' -v OFS='\t' "{print \"$line\", \"corrected\", \$1, \$16, \$17, \$3}" \
  | sed 's/corrected_//' \
> $WD/"$line"_hmm_hit_file_pmoA.tsv ; done

## Then sorting this file based on the read_ID
for line in $(cat $searchfile); do
    sort -k2 $WD/"$line"_hmm_hit_file_pmoA.tsv > $WD/"$line"_hmm_hit_file_sorted_pmoA.tsv
done



### Creating tax file from the alignment in diamond ##

output_path=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift

for line in $(cat $searchfile); do
    awk -F"\t" -v OFS="," '{print $1, $2}' \
    $output_path/no_filter/pmoA/"$line".txt |
    awk -F"," -v  OFS="," 'NR==FNR {a[$1]=$2; next} {print $0, a[$2]}' \
    $output_path/pmoA/IQtree/pmoA_package_tax.csv - \
    | awk -F"," -v  OFS="\t" '{print $1, $3}' \
    > $WD/"$line"_tax.csv
done

##Sorting the tax file
for line in $(cat $searchfile); do
    sort -k1 $WD/"$line"_tax.csv > $WD/"$line"_read_tax_sorted.tsv
done

### Joining and printing header below. Since I join by the tax file, the high E-value reads should be removed, as they are not reported to the read_tax file ###
for line in $(cat $searchfile); do
(join -t $'\t' -1 1 -2 3 -o '2.1 2.2 1.1 1.2 2.4 2.5 2.6' $WD/"$line"_read_tax_sorted.tsv $WD/"$line"_hmm_hit_file_sorted_pmoA.tsv \
 | awk -v OFS='\t' 'BEGIN{print "Sample\tRead\tSequence\tTax\thmm_start\thmm_end\tLength"} {print $0}') \
> $WD/"$line"_position_of_pmoA_hits_corrected.tsv
done

### Removing all files but the position of hits file ###
for line in $(cat $searchfile); do
rm -r $WD/"$line"_tax.csv $WD/"$line"_read_tax_sorted.tsv $WD/"$line"_hmm_hit_file_sorted_pmoA.tsv $WD/"$line"_hmm_hit_file_pmoA.tsv
done