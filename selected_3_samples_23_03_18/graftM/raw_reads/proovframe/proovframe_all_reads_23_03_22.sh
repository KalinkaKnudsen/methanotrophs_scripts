#!/bin/bash
WD=/user_data/kalinka/selected_3_samples_23_03_18/graftM/raw_reads
cd $WD

seqs=$WD/seqs_less_500k
searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt
proovframe_dir=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/proovframe/proovframe
THREADS=15

mkdir -p $WD/proovframe/pmoA
mkdir -p $WD/proovframe/mmoX


temp=/user_data/kalinka/temp
export TMPDIR=/user_data/kalinka/temp

module purge
module load DIAMOND/2.0.9-foss-2020b
module load parallel

####First I need to make tsv files for all the samples
#cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe map -t $THREADS -d \
#/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.dmnd \
#-o $WD/proovframe/pmoA/{}_c1.tsv $seqs/{}.fastq -- -c1

#### Comparing the -- -c1 argument. CHAT says;The -c1 option is specific to the proovframe map command and stands for "minimum coverage of alignment". This option sets the minimum percentage of aligned bases required for the read to be considered in the output. In this case, it is set to 1, which means that any read with at least one aligned base will be included in the output.
#### There is no apparent difference between the two, i will delete the _c1 files. 

cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe map -t $THREADS -d \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.dmnd \
-o $WD/proovframe/pmoA/{}.tsv $seqs/{}.fastq

cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe map -t $THREADS -d \
/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.dmnd \
-o $WD/proovframe/mmoX/{}.tsv $seqs/{}.fastq


##### I need to convert to fasta
module load SeqKit/2.0.0
cat $searchfile | parallel -j3 --tmpdir $temp seqkit fq2fa $seqs/{}.fastq -o $seqs/{}.fasta -j 10

##Then, I will edit the sequences
cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe fix \
-o $WD/proovframe/pmoA/{}_corrected.fa $seqs/{}.fasta $WD/proovframe/pmoA/{}.tsv

cat $searchfile | parallel -j3 --tmpdir $temp $proovframe_dir/bin/proovframe fix \
-o $WD/proovframe/mmoX/{}_corrected.fa $seqs/{}.fasta $WD/proovframe/mmoX/{}.tsv

#### graftM of the corrected reads #####

GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16

ODIR_pmoA=$WD/proovframe/pmoA
ODIR_mmoX=$WD/proovframe/mmoX

mkdir -p $ODIR_mmoX/graftm
mkdir -p $ODIR_mmoX/log

mkdir -p $ODIR_pmoA/graftm
mkdir -p $ODIR_pmoA/log


module load GraftM/0.14.0-foss-2020b

cat $searchfile | parallel -j3 --tmpdir $temp graftM graft --forward $WD/proovframe/mmoX/{}_corrected.fa \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_mmoX/log/{}.log


cat $searchfile | parallel -j3 --tmpdir $temp graftM graft --forward $WD/proovframe/pmoA/{}_corrected.fa \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log

module load SciPy-bundle/2022.05-foss-2020b

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $ODIR_mmoX/combined_count_table_mmoX \
-n 0 -s '\t' -p combined_count_table $ODIR_mmoX/graftm ConsensusLineage

python3 /user_data/kalinka/GraftM/combining_out/join_files.py -e txt -f $ODIR_pmoA/combined_count_table_pmoA \
-n 0 -s '\t' -p combined_count_table $ODIR_pmoA/graftm ConsensusLineage