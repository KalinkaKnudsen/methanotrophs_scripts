#!/bin/bash

WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads
cd $WD
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt
odir=$WD/length_of_hits
output_path=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/diamond_frameshift

#mkdir $output_path/mmoX
#mkdir $output_path/pmoA

module purge
module load DIAMOND/2.0.9-foss-2020b
module load parallel

temp=/user_data/kalinka/temp
export TMPDIR=/user_data/kalinka/temp

db_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.dmnd
db_mmoX=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.dmnd
pmoA_seqs=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.fa
mmoX_seqs=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.fa

THREADS=6
#--frameshift/-F 

#Penalty for frameshifts in DNA-vs-protein alignments. Values around 15 are reasonable for this parameter. 
#Enabling this feature will have the aligner tolerate missing bases in DNA sequences and is most recommended for long, error-prone sequences like MinION reads.
#In the pairwise output format, frameshifts will be indicated by \ and / for a shift by +1 and -1 nucleotide in the direction of translation respectively. Note that this feature is disabled by default.
# The "*" character in the qseq_translated field of the output from DIAMOND blastx indicates that a gap was introduced in the translation due to the frameshift-aware alignment option.

cat $searchfile | parallel -j3 --tmpdir $temp diamond blastx --db $db_pmoA --frameshift 15 --verbose --threads $THREADS -b12 \
-c1 --max-target-seqs 1 -f 6 qseqid sseqid sstart send length slen qstart qend qlen qframe evalue bitscore nident pident \
mismatch qseq_translated qseq --query $odir/pmoA/{}_truncated.fa \
-o $output_path/pmoA/{}.txt --tmpdir /user_data/kalinka/temp  '&>' $output_path/pmoA/{}.log


cat $searchfile | parallel -j3 --tmpdir $temp diamond blastx --db $db_mmoX --frameshift 15 --verbose --threads $THREADS -b12 \
-c1 --max-target-seqs 1 -f 6 qseqid sseqid sstart send length slen qstart qend qlen qframe evalue bitscore nident pident \
mismatch qseq_translated qseq --query $odir/mmoX/{}_truncated.fa \
-o $output_path/mmoX/{}.txt --tmpdir /user_data/kalinka/temp '&>' $output_path/mmoX/{}.log


###Then I want to make a filter that works like what I am doing in the HMM. I do not want to filter in the blastx, because I want to be able to trace back!
####But i could probably do in by working with the blast filters/options ####

#I need to filter at columns "length" which is col 5. That is the length of the alignment. I will set that to 240, and then 400 for mmoX

for line in $(cat $searchfile); do
    awk '{ if ($5 > 240) {print $0}}' \
    $output_path/pmoA/"$line".txt \
    > $output_path/pmoA/"$line"_filter240.txt
done

for line in $(cat $searchfile); do
    awk '{ if ($5 > 400) {print $0}}' \
    $output_path/mmoX/"$line".txt \
    > $output_path/mmoX/"$line"_filter400.txt
done


#### Then, I want to extract the sequences after the filtering. That must be col 1 and col 16
for line in $(cat $searchfile); do
    awk '{{print ">"$1 "\n" $16}}' \
    $output_path/pmoA/"$line"_filter240.txt \
    > $output_path/pmoA/"$line"_filter240_sequences.fa
done

for line in $(cat $searchfile); do
    awk '{{print ">"$1 "\n" $16}}' \
    $output_path/mmoX/"$line"_filter400.txt \
    > $output_path/mmoX/"$line"_filter400_sequences.fa
done


##### I could filter on taxonomy level because they are all aligned to a diamond package. Every read has also been placed by graftM. I wonder if it will get the same classification
#### For now, I will keep all sequences. I will see if I can even make a MSA. I will do so individually for each sample
module purge
module load MAFFT/7.490-GCC-10.2.0-with-extensions

#Concatenating the files with the package sequences;
for line in $(cat $searchfile); do
    cat $output_path/pmoA/"$line"_filter240_sequences.fa $pmoA_seqs \
    > $output_path/pmoA/"$line"_filter240_sequences_with_package.fa
done
for line in $(cat $searchfile); do
    cat $output_path/mmoX/"$line"_filter400_sequences.fa $mmoX_seqs \
    > $output_path/mmoX/"$line"_filter400_sequences_with_package.fa
done

#Generating MSA
for line in $(cat $searchfile); do
    mafft $output_path/pmoA/"$line"_filter240_sequences_with_package.fa \
    > $output_path/pmoA/"$line"_filter240_sequences_with_package_aligned.fa
done

for line in $(cat $searchfile); do
    mafft $output_path/mmoX/"$line"_filter400_sequences_with_package.fa \
    > $output_path/mmoX/"$line"_filter400_sequences_with_package_aligned.fa
done

#And MSA without the package sequences;
for line in $(cat $searchfile); do
    mafft $output_path/pmoA/"$line"_filter240_sequences.fa \
    > $output_path/pmoA/"$line"_filter240_sequences_aligned.fa
done

for line in $(cat $searchfile); do
    mafft $output_path/mmoX/"$line"_filter400_sequences.fa \
    > $output_path/mmoX/"$line"_filter400_sequences_aligned.fa
done




#Trimming at 20% representation and putting the trim into the IQ-tree folder
mkdir $output_path/pmoA/IQtree
mkdir $output_path/mmoX/IQtree

module purge
module load TrimAl/1.4.1-foss-2020b

for line in $(cat $searchfile); do
trimal -in $output_path/pmoA/"$line"_filter240_sequences_with_package_aligned.fa \
 -out $output_path/pmoA/IQtree/"$line"_with_package_trim_20.fa -gt 0.2
done

for line in $(cat $searchfile); do
trimal -in $output_path/mmoX/"$line"_filter400_sequences_with_package_aligned.fa \
 -out $output_path/mmoX/IQtree/"$line"_with_package_trim_20.fa -gt 0.2
done

#And trimming without the package sequences;
for line in $(cat $searchfile); do
trimal -in $output_path/pmoA/"$line"_filter240_sequences_aligned.fa \
 -out $output_path/pmoA/"$line"_trim_20.fa -gt 0.2
done

for line in $(cat $searchfile); do
trimal -in $output_path/mmoX/"$line"_filter400_sequences_aligned.fa \
 -out $output_path/mmoX/"$line"_trim_20.fa -gt 0.2
done

### Trying to work with pplacer


#I think i need to include a package. Here, I will simply try with the graftM package!

module purge
module load pplacer/1.1.alpha19-foss-2020b

pmoA_package=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/pmoA_package_23_03_16.refpkg
mmoX_package=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/mmoX_package_23_03_19.refpkg
module load parallel

#mkdir $output_path/pmoA/pplacer
#mkdir $output_path/mmoX/pplacer

cat $searchfile | parallel -j3 --tmpdir $temp pplacer --out-dir $output_path/pmoA/pplacer --fig-tree $output_path/pmoA/pplacer{} --verbosity 2 \
-c $pmoA_package $output_path/pmoA/IQtree/{}_with_package_trim_20.fa '&>' $output_path/pmoA/pplacer/{}.log

#### Not impressed with this. I will go back to generating a tree with the MSA. 

module load IQ-TREE/2.1.2-gompi-2020b

cat $searchfile | parallel -j3 --tmpdir $temp iqtree2 -s \
$output_path/pmoA/IQtree/{}_with_package_trim_20.fa \
-m MFP -nt AUTO -B 1000 -T $THREADS

cat $searchfile | parallel -j3 --tmpdir $temp iqtree2 -s \
$output_path/mmoX/IQtree/{}_with_package_trim_20.fa \
-m MFP -nt AUTO -B 1000 -T $THREADS



### For some reason, the pmoA package files are missing some lines. Therefore, I will manually add;
# to the /user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/pmoA_package_23_03_16.refpkg/align_pmoA_combined_seqinfo.csv
cat /user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/pmoA_package_23_03_16.refpkg/align_pmoA_combined_seqinfo.csv \
> $output_path/pmoA/IQtree/pmoA_package_tax.csv

echo "contig_43212_6554_5_128_Singleton,Methylocystaceae_pmoA1" >> $output_path/pmoA/IQtree/pmoA_package_tax.csv
echo "contig_2812_22259_5_374_Singleton,Methylocystaceae_pmoA2" >> $output_path/pmoA/IQtree/pmoA_package_tax.csv

cat /user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/mmoX_package_23_03_19.refpkg/combined_mmoX_seqs_seqinfo.csv \
> $output_path/mmoX/IQtree/mmoX_package_tax.csv

### Creating tax file from the alignment in diamond ##
for line in $(cat $searchfile); do
    awk -F"\t" -v OFS="," '{print $1, $2}' \
    $output_path/pmoA/"$line"_filter240.txt |
    awk -F"," -v  OFS="," 'NR==FNR {a[$1]=$2; next} {print $0, a[$2]}' \
    $output_path/pmoA/IQtree/pmoA_package_tax.csv - \
    | awk -F"," -v  OFS="," '{print $1, $3}' \
    > $output_path/pmoA/IQtree/"$line"_tax.csv
done


for line in $(cat $searchfile); do
    awk -F"\t" -v OFS="," '{print $1, $2}' \
    $output_path/mmoX/"$line"_filter400.txt |
    awk -F"," -v  OFS="," 'NR==FNR {a[$1]=$2; next} {print $0, a[$2]}' \
    $output_path/mmoX/IQtree/mmoX_package_tax.csv - \
    | awk -F"," -v  OFS="," '{print $1, $3}' \
    > $output_path/mmoX/IQtree/"$line"_tax.csv
done