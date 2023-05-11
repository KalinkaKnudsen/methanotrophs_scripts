#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/shallow_21_12_2022
cd $WD

########## variables to set ################
MFD1=/projects/microflora_danica/shallow_metagenomes/20003-02_trim/sequences_trim
MFD2=/projects/microflora_danica/shallow_metagenomes/211129_A00595_0124_BHVJMTDSXY_trim/sequences_trim
MFD3=/projects/microflora_danica/shallow_metagenomes/21123-01_trim/sequences_trim
MFD4=/projects/microflora_danica/shallow_metagenomes/220318_A00595_0142_AHVH7CDSXY_trim/sequences_trim
MFD5=/projects/microflora_danica/shallow_metagenomes/220324_A00595_0144_AHGKYMDSX3_trim/sequences_trim
MFD6=/projects/microflora_danica/shallow_metagenomes/220401_A00595_0148_AHGL7FDSX3_trim/sequences_trim
MFD7=/projects/microflora_danica/shallow_metagenomes/220429_A00595_0154_BHHCM7DSX3_trim/sequences_trim
MFD8=/projects/microflora_danica/shallow_metagenomes/220506_A00595_0156_BHH5G2DSX3_trim/sequences_trim
MFD9=/projects/microflora_danica/shallow_metagenomes/220601_A00595_0164_BHKNK7DSX3_trim/sequences_trim
MFD10=/projects/microflora_danica/shallow_metagenomes/220607_A00595_0166_BHKNKHDSX3_trim/sequences_trim
MFD11=/projects/microflora_danica/shallow_metagenomes/220613_A00595_0168_BHKNMYDSX3_trim/sequences_trim
MFD12=/projects/microflora_danica/shallow_metagenomes/220627_A00595_0174_BHMV5KDSX3_trim/sequences_trim
MFD13=/projects/microflora_danica/shallow_metagenomes/220721_A00595_0179_AHMTTHDSX3_trim/sequences_trim
MFD14=/projects/microflora_danica/shallow_metagenomes/220802_A00595_0182_BHMTY7DSX3_trim/sequences_trim
MFD15=/projects/microflora_danica/shallow_metagenomes/220812_A00595_0185_AHVYLFDSX3_trim/sequences_trim



ODIR_mmoX=$WD/mmoX
ODIR_pmoA=$WD/pmoA

THREADS=9
############################################

# load modules
module purge
module load GraftM/0.14.0-foss-2020b
module load parallel


GRAFTM_PACKAGE_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022
GRAFTM_PACKAGE_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22

# make directories for output
mkdir -p $ODIR_mmoX/graftm
mkdir -p $ODIR_mmoX/log

mkdir -p $ODIR_pmoA/graftm
mkdir -p $ODIR_pmoA/log
# temporary folder for parallel
temp=/user_data/kalinka/temp

# make your batch file of the samples you want to run
# make your batch file of the samples you want to run
ls $MFD1 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile1.txt
ls $MFD2 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile2.txt
ls $MFD3 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile3.txt
ls $MFD4 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile4.txt
ls $MFD5 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile5.txt
ls $MFD6 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile6.txt
ls $MFD7 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile7.txt
ls $MFD8 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile8.txt
ls $MFD9 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile9.txt
ls $MFD10 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile10.txt
ls $MFD11 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile11.txt
ls $MFD12 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile12.txt
ls $MFD13 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile13.txt
ls $MFD14 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile14.txt
ls $MFD15 | grep '_R1_fastp.fastq.gz' | sed 's/_R1_fastp.fastq.gz//' > $WD/searchfile15.txt
#
# #run graftM graft in parallel - individually for forward and reverse reads
# # forward
cat $WD/searchfile1.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD1/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile2.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD2/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile3.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD3/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile4.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD4/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile5.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD5/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile6.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD6/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile7.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD7/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile8.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD8/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile9.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD9/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile10.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD10/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile11.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD11/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile12.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD12/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile13.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD13/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile14.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD14/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX

cat $WD/searchfile15.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD15/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_mmoX --output_directory $ODIR_mmoX/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide --search_method hmmsearch+diamond  '&>' $ODIR_mmoX/log/{}.log
 GRAFTM_OUT=$ODIR_mmoX


#pmoA package
cat $WD/searchfile1.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD1/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile1 finished"

cat $WD/searchfile2.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD2/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile2 finished"

cat $WD/searchfile3.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD3/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile3 finished"

cat $WD/searchfile4.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD4/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile4 finished"

cat $WD/searchfile5.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD5/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile5 finished"

cat $WD/searchfile6.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD6/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile6 finished"

cat $WD/searchfile7.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD7/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile7 finished"

cat $WD/searchfile8.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD8/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile8 finished"

cat $WD/searchfile9.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD9/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA
echo "searchfile9 finished"

cat $WD/searchfile10.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD10/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile10 finished"

cat $WD/searchfile11.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD11/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile11 finished"

cat $WD/searchfile12.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD12/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile12 finished"

cat $WD/searchfile13.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD13/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile13 finished"

cat $WD/searchfile14.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD14/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile14 finished"

cat $WD/searchfile15.txt | parallel -j4 --tmpdir $temp graftM graft --forward $MFD15/{}_R1_fastp.fastq.gz \
 --graftm_package $GRAFTM_PACKAGE_pmoA --output_directory $ODIR_pmoA/graftm/{} --verbosity 5 \
 --threads $THREADS --force --input_sequence_type nucleotide  --search_method hmmsearch+diamond '&>' $ODIR_pmoA/log/{}.log
GRAFTM_OUT=$ODIR_pmoA

echo "searchfile15 finished - have a nice day"