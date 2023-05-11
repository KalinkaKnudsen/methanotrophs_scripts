#!/bin/bash

#########  pmoA #############
#MFD01223
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD01223/MFD01223/MFD01223_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD01223.tsv | sort > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD01223.txt


#MFD01248
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD01248/MFD01248/MFD01248_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD01248.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD01248.txt


#MFD03899
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD03899/MFD03899/MFD03899_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03899.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03899.txt

rm /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
rm /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt

#MFD01138
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD01138/MFD01138/MFD01138_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD01138.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD01138.txt

#MFD02979
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD02979/MFD02979/MFD02979_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD02979.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD02979.txt

#MFD03346
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD03346/MFD03346/MFD03346_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03346.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03346.txt

#MFD03726
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD03726/MFD03726/MFD03726_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03726.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03726.txt

#MFD05580
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD05580/MFD05580/MFD05580_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD05580.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD05580.txt


#MFD03399
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD03399/MFD03399/MFD03399_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03399.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03399.txt


#MFD03638
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD03638/MFD03638/MFD03638_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03638.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03638.txt


#MFD04408
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD04408/MFD04408/MFD04408_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD04408.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD04408.txt


#MFD04434
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD04434/MFD04434/MFD04434_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD04434.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD04434.txt


#MFD04967
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD04967/MFD04967/MFD04967_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD04967.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD04967.txt


#MFD10064
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/graftm/MFD10064/MFD10064/MFD10064_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD10064.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD10064.txt

#Group7_7
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/group77/pmoA/graftm/assembly/assembly_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt FS='\t' /srv/MA/Projects/microflora_danica/group77/cov.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt | cut -d " " -f 1,3,6,7,8,9,10,11 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_group7_7.txt


rm /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp2.txt
rm /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/temp1.txt



#########  mmoX #############
#MFD01223
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD01223/MFD01223/MFD01223_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD01223.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD01223.txt


#MFD01248
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD01248/MFD01248/MFD01248_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD01248.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD01248.txt


#MFD03899
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD03899/MFD03899/MFD03899_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03899.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03899.txt


#MFD01138
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD01138/MFD01138/MFD01138_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD01138.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD01138.txt

#MFD02979
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD02979/MFD02979/MFD02979_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD02979.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD02979.txt

#MFD03346
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD03346/MFD03346/MFD03346_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03346.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03346.txt

#MFD03726
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD03726/MFD03726/MFD03726_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03726.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03726.txt

#MFD05580
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD05580/MFD05580/MFD05580_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD05580.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD05580.txt



#MFD03399
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD03399/MFD03399/MFD03399_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03399.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03399.txt


#MFD03638
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD03638/MFD03638/MFD03638_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD03638.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03638.txt


#MFD04408
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD04408/MFD04408/MFD04408_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD04408.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD04408.txt


#MFD04434
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD04434/MFD04434/MFD04434_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD04434.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD04434.txt


#MFD04967
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD04967/MFD04967/MFD04967_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD04967.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD04967.txt


#MFD10064
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/graftm/MFD10064/MFD10064/MFD10064_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /projects/microflora_danica/deep_metagenomes/assembly_info/MFD10064.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d ' ' -f 1,3,9,10,11,12,13,14,15,16 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD10064.txt


#Group7_7
sed 's/\(_[^_]*\)\S*/\1/' /user_data/kalinka/GraftM/long_read_graftM/group77/mmoX/graftm/assembly/assembly_read_tax.tsv | sort | uniq > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt
awk 'NR==FNR{ a[$1]; next }$1 in a'  /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt FS='\t' /srv/MA/Projects/microflora_danica/group77/cov.tsv | sort  > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
join /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt | cut  -d " " -f 1,3,6,7,8,9,10,11 > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_group7_7.txt

rm /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp2.txt
rm /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/temp1.txt

cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD01223.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD01223.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD01223.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD01248.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD01248.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD01248.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03899.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03899.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD03899.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD01138.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD01138.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD01138.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD02979.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD02979.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD02979.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03346.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03346.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD03346.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03726.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03726.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD03726.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD05580.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD05580.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD05580.txt

cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03399.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03399.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD03399.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD03638.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD03638.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD03638.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD04408.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD04408.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD04408.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD04434.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD04434.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD04434.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD04967.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD04967.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD04967.txt
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_MFD10064.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_MFD10064.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD10064.txt

cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/mmoX/cov_matched_group7_7.txt /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/pmoA/cov_matched_group7_7.txt > /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_group7_7.txt