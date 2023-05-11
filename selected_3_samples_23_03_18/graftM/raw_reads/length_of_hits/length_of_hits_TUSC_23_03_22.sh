#!/bin/bash
WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads
cd $WD

seqs=$WD/seqs_less_500k
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt
odir=$WD/length_of_hits
mkdir $odir/mmoX
mkdir $odir/pmoA

#### I will be working with all reads. There is no reason to not include all the reads, also the homologous. 

##Now making subsets for the longer reads
#I DO NOT want to filter on alignment level. I will thus not use awk '{ if ($3 > 240 && $17 - $16 >100)
### I do however want this on read level. Therefore, I remove the translation indicatior (read_*_*_) by awk -F '_' '{print $1}'


for line in $(cat $searchfile); do 
    awk '{ if ($3 > 240) {print $1}}' \
    $WD/pmoA/graftm/$line/"$line"/"$line".hmmout.txt \
    | awk -F '_' '{print $1}' \
    | grep -v "#" \
    | sort | uniq \
    > $odir/pmoA/"$line"_longer_200.hmmout.txt
done

for line in $(cat $searchfile); do 
    awk '{ if ($3 > 400) {print $1}}' \
    $WD/mmoX/graftm/$line/"$line"/"$line".hmmout.txt \
    | awk -F '_' '{print $1}' \
    | grep -v "#" \
    | sort | uniq \
    > $odir/mmoX/"$line"_longer_400.hmmout.txt
done

#And extracting the MSA
for line in $(cat $searchfile); do 
awk '{ if ($3 > 240) {print $1}}' \
    $WD/pmoA/graftm/$line/"$line"/"$line".hmmout.txt \
    | grep -v "#" \
    | grep -A1 --no-group-separator -f \
    - $WD/pmoA/graftm/$line/"$line"/"$line"_hits.aln.fa \
> $odir/pmoA/"$line"_alignment_longer_200.aln.fa \
| echo $line; done


for line in $(cat $searchfile); do 
awk '{ if ($3 > 400) {print $1}}' \
    $WD/mmoX/graftm/$line/"$line"/"$line".hmmout.txt \
    | grep -v "#" \
    | grep -A1 --no-group-separator -f \
    - $WD/mmoX/graftm/$line/"$line"/"$line"_hits.aln.fa \
> $odir/mmoX/"$line"_alignment_longer_400.aln.fa \
| echo $line; done


##Now I want to subset the short reads and their alignments
for line in $(cat $searchfile); do 
    awk '{ if ($3 < 240) {print $1}}' \
    $WD/pmoA/graftm/$line/"$line"/"$line".hmmout.txt \
    | awk -F '_' '{print $1}' \
    | grep -v "#" \
    | sort | uniq \
    > $odir/pmoA/"$line"_shorter_200.hmmout.txt
done

for line in $(cat $searchfile); do 
    awk '{ if ($3 < 400) {print $1}}' \
    $WD/mmoX/graftm/$line/"$line"/"$line".hmmout.txt \
    | awk -F '_' '{print $1}' \
    | grep -v "#" \
    | sort | uniq \
    > $odir/mmoX/"$line"_shorter_400.hmmout.txt
done

for line in $(cat $searchfile); do 
awk '{ if ($3 < 240) {print $1}}' \
    $WD/pmoA/graftm/$line/"$line"/"$line".hmmout.txt \
    | grep -v "#" \
    | grep -A1 --no-group-separator -f \
    - $WD/pmoA/graftm/$line/"$line"/"$line"_hits.aln.fa \
> $odir/pmoA/"$line"_alignment_shorter_200.aln.fa \
| echo $line; done


for line in $(cat $searchfile); do 
awk '{ if ($3 < 400) {print $1}}' \
    $WD/mmoX/graftm/$line/"$line"/"$line".hmmout.txt \
    | grep -v "#" \
    | grep -A1 --no-group-separator -f \
    - $WD/mmoX/graftm/$line/"$line"/"$line"_hits.aln.fa \
> $odir/mmoX/"$line"_alignment_shorter_400.aln.fa \
| echo $line; done




###### Now, I want to generate a file that prints the number of full length and too short sequences for each sample.
echo "Sample  Reads_longer_240  Reads_shorter_240" \
> $odir/pmoA/seq_overview.tsv

while read -r line; do
  longer_file="$odir/pmoA/"$line"_longer_200.hmmout.txt"
  shorter_file="$odir/pmoA/"$line"_shorter_200.hmmout.txt"
  longer_lines=$(wc -l < "$longer_file")
  shorter_lines=$(wc -l < "$shorter_file")
  printf "%s\t%s\t%s\n" "$line" "$longer_lines" "$shorter_lines" >> "$odir/pmoA/seq_overview.tsv"
done < "$searchfile"

echo "Sample  Reads_longer_400  Reads_shorter_400" \
> $odir/mmoX/seq_overview.tsv

while read -r line; do
  longer_file="$odir/mmoX/"$line"_longer_400.hmmout.txt"
  shorter_file="$odir/mmoX/"$line"_shorter_400.hmmout.txt"
  longer_lines=$(wc -l < "$longer_file")
  shorter_lines=$(wc -l < "$shorter_file")
  printf "%s\t%s\t%s\n" "$line" "$longer_lines" "$shorter_lines" >> "$odir/pmoA/seq_overview.tsv"
done < "$searchfile"

##################################### Here #################################################