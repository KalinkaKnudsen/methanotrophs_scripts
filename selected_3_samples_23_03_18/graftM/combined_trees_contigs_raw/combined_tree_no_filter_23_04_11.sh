#!/bin/bash

WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/combined_trees_contigs_raw/tree_for_LC
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

#### And then finally adding in the package sequences
pmoA_seqs=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.fa
mmoX_seqs=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.fa

for line in $(cat $searchfile); do
    cat $pmoA_seqs >> $WD/pmoA/"$line".fa
done 

##Then clustering at 100% identity:

for line in $(cat $searchfile); do
usearch -cluster_fast $WD/pmoA/"$line".fa \
-id 1 -centroids $WD/pmoA/"$line"_cluster1.fa &> $WD/pmoA/"$line"_cluster.log
done

### And finally running MSA, trim and tree-building

module load MAFFT/7.490-GCC-10.2.0-with-extensions

for line in $(cat $searchfile); do
    mafft $WD/pmoA/"$line"_cluster1.fa \
    > $WD/pmoA/"$line"_align.fa
done


#Trimming at 20% representation and putting the trim into the IQ-tree folder
mkdir $WD/pmoA/IQtree

module load TrimAl/1.4.1-foss-2020b

for line in $(cat $searchfile); do
trimal -in $WD/pmoA/"$line"_align.fa \
 -out $WD/pmoA/IQtree/"$line"_align_20pct.fa -gt 0.2
done


module load IQ-TREE/2.1.2-gompi-2020b
module load parallel
temp=/user_data/kalinka/temp
export TMPDIR=/user_data/kalinka/temp

cat $searchfile | parallel -j3 --tmpdir $temp iqtree2 -s \
$WD/pmoA/IQtree/{}_align_20pct.fa -redo \
-m MFP -nt AUTO -B 1000 -T 12



###Creating tax files
#For the contigs and raw reads, I can just use the graftM taxfiles
for line in $(cat $searchfile); do 
    cat $contigs/pmoA/graftm/$line/"$line"_assembly/"$line"_assembly_read_tax.tsv \
    > $WD/pmoA/"$line"_tax.tsv
done


#### And then I have made tax files for the truncated reads in antoher file
output_path=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift

for line in $(cat $searchfile); do
    awk -F"\t" -v OFS="," '{print $1, $2}' \
    $output_path/no_filter/pmoA/"$line"_filter240.txt |
    awk -F"," -v  OFS="," 'NR==FNR {a[$1]=$2; next} {print $0, a[$2]}' \
    $output_path/pmoA/IQtree/pmoA_package_tax.csv - \
    | awk -F"," -v  OFS="\t" '{print $1, $3}' | sed 's/^/corrected_/' \
    >> $WD/pmoA/"$line"_tax.tsv
done

### I have package tax in my graftM folder #