#!/bin/bash

WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/combined_trees_contigs_raw
cd $WD
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt
contigs=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs
raw_reads=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads

mkdir $WD/mmoX
mkdir $WD/pmoA

###I have already sorted for full length raw reads and corrected raw reads in scripts
#/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift/diamond_frameshift_23_03_28.sh
#/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/length_of_hits/length_of_hits_23_03_22.sh


### I need to pull full length reads from the contigs ##
### However, do I even care about the hmmout file. Probably just grep againt for the actual sequence!

## And I will just append everything to the same file, do not want 3 intermediate files
module load SeqKit/2.0.0

for line in $(cat $searchfile); do
    cat $contigs/pmoA/graftm/$line/"$line"_assembly/"$line"_assembly_read_tax.tsv \
    | grep -w "Root;" \
    | grep -v "Root; Homologous_MO" \
    | awk '{print $1}' \
    | grep -f - $contigs/pmoA/graftm/$line/"$line"_assembly/"$line"_assembly.hmmout.txt \
    | awk '{ if ($3 > 240) {print $1}}' - \
    | seqkit grep -f - $contigs/pmoA/graftm/$line/"$line"_assembly/"$line"_assembly_orf.fa \
    > $WD/pmoA/"$line".fa
done

for line in $(cat $searchfile); do
    cat $contigs/mmoX/graftm/$line/"$line"_assembly/"$line"_assembly_read_tax.tsv \
    | grep -w "Root;" \
    | grep -v "Root; Homologous_mmoX" \
    | awk '{print $1}' \
    | grep -f - $contigs/mmoX/graftm/$line/"$line"_assembly/"$line"_assembly.hmmout.txt \
    | awk '{ if ($3 > 400) {print $1}}' - \
    | seqkit grep -f - $contigs/mmoX/graftm/$line/"$line"_assembly/"$line"_assembly_orf.fa \
    > $WD/mmoX/"$line".fa
done

##### Then; I want to append the raw reads to this file. The ones with original full length before correction

for line in $(cat $searchfile); do 
    cat $raw_reads/pmoA/graftm/$line/"$line"/"$line"_read_tax.tsv \
    | grep -w "Root;" \
    | grep -v "Root; Homologous_MO" \
    | awk '{print $1}' \
    | grep -f - $raw_reads/pmoA/graftm/$line/"$line"/"$line".hmmout.txt \
    | awk '{ if ($3 > 240) {print $1}}' - \
    | seqkit grep -f - $raw_reads/pmoA/graftm/$line/"$line"/"$line"_orf.fa \
    | sed 's/>/>raw_/' | awk -F" " '{print $1}' \
    >> $WD/pmoA/"$line".fa
done


for line in $(cat $searchfile); do 
    cat $raw_reads/mmoX/graftm/$line/"$line"/"$line"_read_tax.tsv \
    | grep -w "Root;" \
    | grep -v "Root; Homologous_mmoX" \
    | awk '{print $1}' \
    | grep -f - $raw_reads/mmoX/graftm/$line/"$line"/"$line".hmmout.txt \
    | awk '{ if ($3 > 400) {print $1}}' - \
    | seqkit grep -f - $raw_reads/mmoX/graftm/$line/"$line"/"$line"_orf.fa \
    | sed 's/>/>raw_/' | awk -F" " '{print $1}' \
    >> $WD/mmoX/"$line".fa
done


#### And then adding the corrected truncated reads. 
### Here, I also need to filter for taxonomy. I will do this based on the sequence it was corrected to in the frameshift correction tool
mmoX_tax=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift/mmoX/IQtree/mmoX_package_tax.csv
pmoA_tax=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift/pmoA/IQtree/pmoA_package_tax.csv

for line in $(cat $searchfile); do
    cat $pmoA_tax | grep -v "Nitrosococcus" | grep -v "Cycloclasticus" \
    | grep -v "Homologous_MO" | grep -v "Nitrospira_clade_B" | grep -v "Nitrospira_clade_A" \
    | grep -v "Actinobacteria" | grep -v "HMO_cluster" | grep -v "Homologous_pmoA" | grep -v "Homologous_Binatota" \
    | awk -F"," '{print $1}' | grep -f - $raw_reads/diamond_frameshift/pmoA/"$line"_filter240.txt \
    | awk '{{print ">"$1 "\n" $16}}' | sed 's/>/>corrected_/' \
    >> $WD/pmoA/"$line".fa
done


for line in $(cat $searchfile); do
    cat $mmoX_tax | grep -v "Homologous_mmoX" | grep -v "Propane_monooxygenase" \
    | grep -v "Actinomycetes" | grep -v "Butane_monooxygenase" \
    | awk -F"," '{print $1}' | grep -f - $raw_reads/diamond_frameshift/mmoX/"$line"_filter400.txt \
    | awk '{{print ">"$1 "\n" $16}}' | sed 's/>/>corrected_/'\
    >> $WD/mmoX/"$line".fa
done

#### And then finally adding in the package sequences
pmoA_seqs=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.fa
mmoX_seqs=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.fa

for line in $(cat $searchfile); do
    cat $pmoA_seqs >> $WD/pmoA/"$line".fa
done 

for line in $(cat $searchfile); do
    cat $mmoX_seqs >> $WD/mmoX/"$line".fa
done

##Then clustering at 100% identity:

for line in $(cat $searchfile); do
usearch -cluster_fast $WD/pmoA/"$line".fa \
-id 1 -centroids $WD/pmoA/"$line"_cluster1.fa &> $WD/pmoA/"$line"_cluster.log
done

for line in $(cat $searchfile); do
usearch -cluster_fast $WD/mmoX/"$line".fa \
-id 1 -centroids $WD/mmoX/"$line"_cluster1.fa &> $WD/mmoX/"$line"_cluster.log
done
### And finally running MSA, trim and tree-building

module load MAFFT/7.490-GCC-10.2.0-with-extensions

for line in $(cat $searchfile); do
    mafft $WD/pmoA/"$line"_cluster1.fa \
    > $WD/pmoA/"$line"_align.fa
done

for line in $(cat $searchfile); do
    mafft $WD/mmoX/"$line"_cluster1.fa \
    > $WD/mmoX/"$line"_align.fa
done

#Trimming at 20% representation and putting the trim into the IQ-tree folder
mkdir $WD/pmoA/IQtree
mkdir $WD/mmoX/IQtree

module load TrimAl/1.4.1-foss-2020b

for line in $(cat $searchfile); do
trimal -in $WD/pmoA/"$line"_align.fa \
 -out $WD/pmoA/IQtree/"$line"_align_20pct.fa -gt 0.2
done

for line in $(cat $searchfile); do
trimal -in $WD/mmoX/"$line"_align.fa \
 -out $WD/mmoX/IQtree/"$line"_align_20pct.fa -gt 0.2
done

module load IQ-TREE/2.1.2-gompi-2020b
module load parallel
temp=/user_data/kalinka/temp
export TMPDIR=/user_data/kalinka/temp

cat $searchfile | parallel -j3 --tmpdir $temp iqtree2 -s \
$WD/pmoA/IQtree/{}_align_20pct.fa -redo \
-m MFP -nt AUTO -B 1000 -T 10

cat $searchfile | parallel -j3 --tmpdir $temp iqtree2 -s \
$WD/mmoX/IQtree/{}_align_20pct.fa -redo \
-m MFP -nt AUTO -B 1000 -T 10


###Creating tax files
#For the contigs and raw reads, I can just use the graftM taxfiles
for line in $(cat $searchfile); do 
    cat $contigs/pmoA/graftm/$line/"$line"_assembly/"$line"_assembly_read_tax.tsv \
    > $WD/pmoA/"$line"_tax.tsv
done

for line in $(cat $searchfile); do 
    cat $contigs/mmoX/graftm/$line/"$line"_assembly/"$line"_assembly_read_tax.tsv \
    > $WD/mmoX/"$line"_tax.tsv
done

for line in $(cat $searchfile); do 
    sed 's/^/raw_/' $raw_reads/pmoA/graftm/$line/"$line"/"$line"_read_tax.tsv \
    >> $WD/pmoA/"$line"_tax.tsv
done

for line in $(cat $searchfile); do 
    sed 's/^/raw_/' $raw_reads/mmoX/graftm/$line/"$line"/"$line"_read_tax.tsv \
    >> $WD/mmoX/"$line"_tax.tsv
done

#### And then I have made tax files for the truncated reads in antoher file
for line in $(cat $searchfile); do 
    sed 's/^/corrected_/' $raw_reads/diamond_frameshift/pmoA/IQtree/"$line"_tax.csv \
    | sed 's/,/\t/g' \
    >> $WD/pmoA/"$line"_tax.tsv
done

for line in $(cat $searchfile); do 
    sed 's/^/corrected_/' $raw_reads/diamond_frameshift/mmoX/IQtree/"$line"_tax.csv \
    | sed 's/,/\t/g' \
    >> $WD/mmoX/"$line"_tax.tsv
done

###I want to keep the package identification for itself - I want to be able to turn this off/on in the tree
echo "Sample  contig_lines  raw_lines   corrected_lines" > "$WD/pmoA/seq_overview.tsv"

while read -r line; do
  seq_file="$WD/pmoA/"$line".fa"
  contig_lines=$(grep ">contig" $seq_file | wc -l)
  raw_lines=$(grep "raw" $seq_file | wc -l)
  corrected_lines=$(grep "corrected" $seq_file | wc -l)
  printf "%s\t%s\t%s\t%s\n" "$line" "$contig_lines" "$raw_lines" "$corrected_lines" >> "$WD/pmoA/seq_overview.tsv"
done < "$searchfile"


echo "Sample  contig_lines  raw_lines   corrected_lines" > $WD/mmoX/seq_overview.tsv

while read -r line; do
  seq_file="$WD/mmoX/"$line".fa"
  contig_lines=$(grep ">contig" $seq_file | wc -l)
  raw_lines=$(grep "raw" $seq_file | wc -l)
  corrected_lines=$(grep "corrected" $seq_file | wc -l)
  printf "%s\t%s\t%s\t%s\n" "$line" "$contig_lines" "$raw_lines" "$corrected_lines" >> "$WD/mmoX/seq_overview.tsv"
done < "$searchfile"