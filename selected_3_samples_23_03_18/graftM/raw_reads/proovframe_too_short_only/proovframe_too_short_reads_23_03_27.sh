#!/bin/bash
WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads
ODIR=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/proovframe_too_short_only
cd $WD

mkdir $ODIR/mmoX
mkdir $ODIR/pmoA

pmoA_short_seq_ID=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/length_of_hits/pmoA
mmoX_short_seq_ID=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads/length_of_hits/mmoX
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt

proovframe_dir=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/proovframe/proovframe
THREADS=4

temp=/user_data/kalinka/temp
export TMPDIR=/user_data/kalinka/temp

module purge
module load DIAMOND/2.0.9-foss-2020b
module load parallel


### Obtaining the too short reads on DNA-level #####
module load SeqKit/2.0.0


for line in $(cat $searchfile); do 
    seqkit grep -f $mmoX_short_seq_ID/"$line"_shorter_400.hmmout.txt \
    $WD/mmoX/graftm/"$line"/"$line"/"$line"_hits.fa > $ODIR/mmoX/"$line"_short.fa
done

for line in $(cat $searchfile); do 
    seqkit grep -f $pmoA_short_seq_ID/"$line"_shorter_200.hmmout.txt \
    $WD/pmoA/graftm/"$line"/"$line"/"$line"_hits.fa > $ODIR/pmoA/"$line"_short.fa
done


### Generating the searchfile
#The host system is detected to have 1077 GB of RAM. It is recommended to use this parameter for better performance: -c1
cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe map -t $THREADS -d \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.dmnd \
-o $ODIR/pmoA/{}.tsv $ODIR/pmoA/{}_short.fa -- -c1

cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe map -t $THREADS -d \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.dmnd \
-o $ODIR/mmoX/{}.tsv $ODIR/mmoX/{}_short.fa -- -c1


##Then, I will edit the sequences
cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe fix \
-o $ODIR/pmoA/{}_corrected.fa $ODIR/pmoA/{}_short.fa $ODIR/pmoA/{}.tsv  '&>' $ODIR/pmoA/{}.log

cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe fix \
-o $ODIR/mmoX/{}_corrected.fa $ODIR/mmoX/{}_short.fa $ODIR/mmoX/{}.tsv  '&>' $ODIR/mmoX/{}.log

#### graftM of the corrected reads #####

GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16

ODIR_pmoA=$ODIR/pmoA
ODIR_mmoX=$ODIR/mmoX

mkdir -p $ODIR_mmoX/graftm
mkdir -p $ODIR_mmoX/log

mkdir -p $ODIR_pmoA/graftm
mkdir -p $ODIR_pmoA/log


module load GraftM/0.14.0-foss-2020b

cat $searchfile | parallel -j3 --tmpdir $temp graftM graft --forward $ODIR/mmoX/{}_corrected.fa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/log/{}.log


cat $searchfile | parallel -j3 --tmpdir $temp graftM graft --forward $ODIR/pmoA/{}_corrected.fa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log



################# Evaluating the length of the corrected hits ######################

odir_length=$ODIR/length_of_corrected_hits
mkdir $odir_length/mmoX
mkdir $odir_length/pmoA


for line in $(cat $searchfile); do 
    awk '{ if ($3 > 240) {print $1}}' \
    $ODIR_pmoA/graftm/$line/"$line"_corrected/"$line"_corrected.hmmout.txt \
    | awk -F '_' '{print $1}' \
    | grep -v "#" \
    | sort | uniq \
    > $odir_length/pmoA/"$line"_longer_200.hmmout.txt
done

for line in $(cat $searchfile); do 
    awk '{ if ($3 > 400) {print $1}}' \
    $ODIR_mmoX/graftm/$line/"$line"_corrected/"$line"_corrected.hmmout.txt \
    | awk -F '_' '{print $1}' \
    | grep -v "#" \
    | sort | uniq \
    > $odir_length/mmoX/"$line"_longer_400.hmmout.txt
done

#And extracting the MSA
for line in $(cat $searchfile); do 
awk '{ if ($3 > 240) {print $1}}' \
    $ODIR_pmoA/graftm/$line/"$line"_corrected/"$line"_corrected.hmmout.txt \
    | grep -v "#" \
    | grep -A1 --no-group-separator -f \
    - $ODIR_pmoA/graftm/$line/"$line"_corrected/"$line"_corrected_hits.aln.fa \
> $odir_length/pmoA/"$line"_alignment_longer_200.aln.fa \
| echo $line; done


for line in $(cat $searchfile); do 
awk '{ if ($3 > 400) {print $1}}' \
    $ODIR_mmoX/graftm/$line/"$line"_corrected/"$line"_corrected.hmmout.txt \
    | grep -v "#" \
    | grep -A1 --no-group-separator -f \
    - $ODIR_mmoX/graftm/$line/"$line"_corrected/"$line"_corrected_hits.aln.fa \
> $odir_length/mmoX/"$line"_alignment_longer_400.aln.fa \
| echo $line; done


##Now I want to subset the short reads and their alignments
for line in $(cat $searchfile); do 
    awk '{ if ($3 < 240) {print $1}}' \
    $ODIR_pmoA/graftm/$line/"$line"_corrected/"$line"_corrected.hmmout.txt \
    | awk -F '_' '{print $1}' \
    | grep -v "#" \
    | sort | uniq \
    > $odir_length/pmoA/"$line"_shorter_200.hmmout.txt
done

for line in $(cat $searchfile); do 
    awk '{ if ($3 < 400) {print $1}}' \
    $ODIR_mmoX/graftm/$line/"$line"_corrected/"$line"_corrected.hmmout.txt \
    | awk -F '_' '{print $1}' \
    | grep -v "#" \
    | sort | uniq \
    > $odir_length/mmoX/"$line"_shorter_400.hmmout.txt
done

#And extracting the MSA
for line in $(cat $searchfile); do 
awk '{ if ($3 < 240) {print $1}}' \
    $ODIR_pmoA/graftm/$line/"$line"_corrected/"$line"_corrected.hmmout.txt \
    | grep -v "#" \
    | grep -A1 --no-group-separator -f \
    - $ODIR_pmoA/graftm/$line/"$line"_corrected/"$line"_corrected_hits.aln.fa \
> $odir_length/pmoA/"$line"_alignment_shorter_200.aln.fa \
| echo $line; done


for line in $(cat $searchfile); do 
awk '{ if ($3 < 400) {print $1}}' \
    $ODIR_mmoX/graftm/$line/"$line"_corrected/"$line"_corrected.hmmout.txt \
    | grep -v "#" \
    | grep -A1 --no-group-separator -f \
    - $ODIR_mmoX/graftm/$line/"$line"_corrected/"$line"_corrected_hits.aln.fa \
> $odir_length/mmoX/"$line"_alignment_shorter_400.aln.fa \
| echo $line; done


###### Now, I want to generate a file that prints the number of full length and too short sequences for each sample.
echo "Sample  Reads_longer_240  Reads_shorter_240" \
> $odir_length/pmoA/seq_overview.tsv

while read -r line; do
  longer_file="$odir_length/pmoA/"$line"_longer_200.hmmout.txt"
  shorter_file="$odir_length/pmoA/"$line"_shorter_200.hmmout.txt"
  longer_lines=$(wc -l < "$longer_file")
  shorter_lines=$(wc -l < "$shorter_file")
  printf "%s\t%s\t%s\n" "$line" "$longer_lines" "$shorter_lines" >> "$odir_length/pmoA/seq_overview.tsv"
done < "$searchfile"

echo "Sample  Reads_longer_400  Reads_shorter_400" \
> $odir_length/mmoX/seq_overview.tsv

while read -r line; do
  longer_file="$odir_length/mmoX/"$line"_longer_400.hmmout.txt"
  shorter_file="$odir_length/mmoX/"$line"_shorter_400.hmmout.txt"
  longer_lines=$(wc -l < "$longer_file")
  shorter_lines=$(wc -l < "$shorter_file")
  printf "%s\t%s\t%s\n" "$line" "$longer_lines" "$shorter_lines" >> "$odir_length/mmoX/seq_overview.tsv"
done < "$searchfile"



### If I want to do the graftM output
#module load SciPy-bundle/2022.05-foss-2020b

#python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $ODIR_mmoX/combined_count_table_mmoX \
#-n 0 -s '\t' -p combined_count_table $ODIR_mmoX/graftm ConsensusLineage

#python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $ODIR_pmoA/combined_count_table_pmoA \
#-n 0 -s '\t' -p combined_count_table $ODIR_pmoA/graftm ConsensusLineage