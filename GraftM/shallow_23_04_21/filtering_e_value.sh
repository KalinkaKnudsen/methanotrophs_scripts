#!/bin/bash

#set working directory
WD=/user_data/kalinka/GraftM/shallow_23_04_21
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

THREADS=5
############################################

# load modules
module purge



#Combining the searchfiles;
#cat $WD/searchfile1.txt $WD/searchfile2.txt $WD/searchfile3.txt $WD/searchfile4.txt $WD/searchfile5.txt \
# $WD/searchfile6.txt $WD/searchfile7.txt $WD/searchfile8.txt $WD/searchfile9.txt $WD/searchfile10.txt \
#$WD/searchfile11.txt $WD/searchfile12.txt $WD/searchfile13.txt $WD/searchfile14.txt $WD/searchfile15.txt \
#>> $WD/searchfile_combined.txt


for line in $(cat $WD/searchfile_combined.txt); do
  output_file="$ODIR_pmoA/graftm/"$line"/combined_count_table_e10.txt"
  echo -e "#ID\t$line\tConsensusLineage" > "$output_file"
  count=1
  awk '{ if ($12 < 1e-10) {print $1}}' $ODIR_pmoA/graftm/"$line"/"$line"_R1_fastp/"$line"_R1_fastp.hmmout.txt \
    | grep -f - $ODIR_pmoA/graftm/"$line"/"$line"_R1_fastp/"$line"_R1_fastp_read_tax.tsv \
    | cut -f 2 | sort | uniq -c | sed -e 's/^[ \t]*//' | sed 's/\([[:digit:]]\)\s\+Root/\1\tRoot/' \
    | while read -r line2; do
        echo -e "$count\t$line2" >> "$output_file"
        ((count++))
      done
done

module load SciPy-bundle/2022.05-foss-2020b
python3 /user_data/kalinka/join_files.py -e txt -f $WD/combined_count_table_e10_pmoA \
-n 0 -s '\t' -p combined_count_table_e10 $ODIR_pmoA/graftm ConsensusLineage


for line in $(cat $WD/searchfile_combined.txt); do
  output_file="$ODIR_mmoX/graftm/"$line"/combined_count_table_e10.txt"
  echo -e "#ID\t$line\tConsensusLineage" > "$output_file"
  count=1
  awk '{ if ($12 < 1e-10) {print $1}}' $ODIR_mmoX/graftm/"$line"/"$line"_R1_fastp/"$line"_R1_fastp.hmmout.txt \
    | grep -f - $ODIR_mmoX/graftm/"$line"/"$line"_R1_fastp/"$line"_R1_fastp_read_tax.tsv \
    | cut -f 2 | sort | uniq -c | sed -e 's/^[ \t]*//' | sed 's/\([[:digit:]]\)\s\+Root/\1\tRoot/' \
    | while read -r line2; do
        echo -e "$count\t$line2" >> "$output_file"
        ((count++))
      done
done

python3 /user_data/kalinka/join_files.py -e txt -f $WD/combined_count_table_e10_mmoX \
-n 0 -s '\t' -p combined_count_table_e10 $ODIR_mmoX/graftm ConsensusLineage

