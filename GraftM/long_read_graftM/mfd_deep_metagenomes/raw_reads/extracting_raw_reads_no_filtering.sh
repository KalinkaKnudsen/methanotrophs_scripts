#!/bin/bash
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
ODIR_pmoA=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/pmoA
ODIR_mmoX=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads/no_filtering/mmoX
THREADS=30
cd $WD


########### Now to the proveframe correction of all the reads! ##################
module purge
module load DIAMOND/2.0.9-foss-2020b

for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t $THREADS -d \
/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.dmnd \
-o $ODIR_pmoA/"$line".tsv $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.fa -- -c1; done

for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t $THREADS -d \
/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.dmnd \
-o $ODIR_mmoX/"$line".tsv $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.fa -- -c1; done

##Then, I will edit the sequences
for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
-o $ODIR_pmoA/"$line"_corrected.fa \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.fa \
$ODIR_pmoA/"$line".tsv; done

for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
-o $ODIR_mmoX/"$line"_corrected.fa \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.fa \
$ODIR_mmoX/"$line".tsv; done

###Translation to CDS's
module purge
module load OrfM/0.7.1-foss-2020b

for line in $(cat $WD/searchfile.txt); do orfm $ODIR_pmoA/"$line"_corrected.fa \
> $ODIR_pmoA/"$line"_corrected_CDS.fa; done

for line in $(cat $WD/searchfile.txt); do orfm $ODIR_mmoX/"$line"_corrected.fa \
> $ODIR_mmoX/"$line"_corrected_CDS.fa; done

###And now trying to do HMMscan
module purge
module load HMMER/3.3.2-foss-2020b

#I am setting the E-value to 0.0001 to ensure that I only get the hits that I want!
for line in $(cat $WD/searchfile.txt); do hmmsearch -E 0.0001 --domtblout \
$ODIR_pmoA/"$line"_hmmout.txt \
/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/graftmdica0r27_search.hmm \
$ODIR_pmoA/"$line"_corrected_CDS.fa; done

for line in $(cat $WD/searchfile.txt); do hmmsearch -E 0.0001 --domtblout \
$ODIR_mmoX/"$line"_hmmout.txt \
/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/graftmn0ssxnot_search.hmm \
$ODIR_mmoX/"$line"_corrected_CDS.fa; done

module purge

#Now I want to extract the sequences that hit in the HMM from the CDS_file. 
for line in $(cat $WD/searchfile.txt); do  awk '{ if ($3 > 240 && $17 - $16 >100) {print ">"$1}}' \
$ODIR_pmoA/"$line"_hmmout.txt > $ODIR_pmoA/"$line"_temp1.txt; done

for line in $(cat $WD/searchfile.txt); do  awk '{ if ($3 > 400 && $17 - $16 >100) {print ">"$1}}' \
$ODIR_mmoX/"$line"_hmmout.txt > $ODIR_mmoX/"$line"_temp1.txt; done


for line in $(cat $WD/searchfile.txt); do grep -A1 -wf $ODIR_pmoA/"$line"_temp1.txt \
$ODIR_pmoA/"$line"_corrected_CDS.fa \
| sed 's/--//' > $ODIR_pmoA/"$line"_corrected_hits.fa; done

for line in $(cat $WD/searchfile.txt); do grep -A1 -wf $ODIR_mmoX/"$line"_temp1.txt \
$ODIR_mmoX/"$line"_corrected_CDS.fa \
| sed 's/--//' > $ODIR_mmoX/"$line"_corrected_hits.fa; done


##Removing unwanted and temp files;
for line in $(cat $WD/searchfile.txt); do rm $ODIR_pmoA/"$line"_temp1.txt; done

for line in $(cat $WD/searchfile.txt); do rm $ODIR_mmoX/"$line"_temp1.txt; done



###Clustering at 80%
for line in $(cat $WD/searchfile.txt); do usearch -cluster_fast $ODIR_pmoA/"$line"_corrected_hits.fa \
-id 0.8 -centroids $ODIR_pmoA/"$line"_corrected_hits_08.fa; done

for line in $(cat $WD/searchfile.txt); do usearch -cluster_fast $ODIR_mmoX/"$line"_corrected_hits.fa \
-id 0.8 -centroids $ODIR_mmoX/"$line"_corrected_hits_08.fa; done

###For fun I want to contencate everything and try to re-cluster that!

for line in $(cat $WD/searchfile.txt); do cat $ODIR_pmoA/"$line"_corrected_hits_08.fa \
>> $ODIR_pmoA/combined_pmoA_raw.fa ;done

for line in $(cat $WD/searchfile.txt); do cat $ODIR_mmoX/"$line"_corrected_hits_08.fa \
>> $ODIR_mmoX/combined_mmoX_raw.fa ;done



sed -i 's/runid.*//g' $ODIR_pmoA/combined_pmoA_raw.fa
sed -i 's/>/>MFD_raw_read_/' $ODIR_pmoA/combined_pmoA_raw.fa

sed -i 's/runid.*//g' $ODIR_mmoX/combined_mmoX_raw.fa
sed -i 's/>/>MFD_raw_read_/' $ODIR_mmoX/combined_mmoX_raw.fa


module purge
module load DIAMOND/2.0.9-foss-2020b

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $ODIR_mmoX/combined_mmoX_raw.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $ODIR_mmoX/combined_mmoX_raw_balst_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp 

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $ODIR_pmoA/combined_pmoA_raw.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $ODIR_pmoA/combined_pmoA_raw_balst_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp
module purge


awk -F'\t' '{print $2" ,"$1}' $ODIR_mmoX/combined_mmoX_raw_balst_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1,[/;s/\].*$/\]/' | sed 's/ ,/,/'> $ODIR_mmoX/tax_file_mmoX_raw.csv

awk -F'\t' '{print $2" ,"$1}' $ODIR_pmoA/combined_pmoA_raw_balst_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1,[/;s/\].*$/\]/'| sed 's/ ,/,/'> $ODIR_pmoA/tax_file_pmoA_raw.csv



########################### Now to the contigs #######################
WD_Contig=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes

for line in $(cat $WD_Contig/searchfile1.txt); do awk '{ if ($3 > 240 && $17 - $16 >100) {print ">"$1}}'  $WD_Contig/pmoA/graftm/$line/$line/"$line"_hmmout.txt \
> $WD_Contig/pmoA/graftm/$line/$line/"$line"_longer_200.hmmout.txt; done

for line in $(cat $WD_Contig/searchfile1.txt); do awk '{ if ($3 > 400 && $17 - $16 >100) {print ">"$1}}'  $WD_Contig/mmoX/graftm/$line/$line/"$line"_hmmout.txt \
> $WD_Contig/mmoX/graftm/$line/$line/"$line"_longer_200.hmmout.txt; done

for line in $(cat $WD_Contig/searchfile1.txt); do grep -A1 -wf $WD_Contig/pmoA/graftm/$line/$line/"$line"_longer_200.hmmout.txt \
$WD_Contig/pmoA/graftm/$line/$line/"$line"_orf.fa | sed 's/--//' \
> $WD_Contig/pmoA/graftm/$line/$line/"$line"_orf_long.fa \
| echo $line; done

for line in $(cat $WD_Contig/searchfile1.txt); do grep -A1 -wf $WD_Contig/mmoX/graftm/$line/$line/"$line"_longer_200.hmmout.txt \
$WD_Contig/mmoX/graftm/$line/$line/"$line"_orf.fa | sed 's/--//' \
> $WD_Contig/mmoX/graftm/$line/$line/"$line"_orf_long.fa \
| echo $line; done


###Contencating the files
for line in $(cat $WD_Contig/searchfile1.txt); do cat $WD_Contig/pmoA/graftm/$line/$line/"$line"_orf_long.fa \
>> $WD_Contig/pmoA/combined_contigs_pmoA.fa ;done

for line in $(cat $WD_Contig/searchfile1.txt); do cat $WD_Contig/mmoX/graftm/$line/$line/"$line"_orf_long.fa \
>> $WD_Contig/mmoX/combined_contigs_mmoX.fa ;done


###Clustering at 100%
for line in $(cat $WD/searchfile.txt); do usearch -cluster_fast $WD_Contig/pmoA/combined_contigs_pmoA.fa \
-id 1 -centroids $WD_Contig/pmoA/combined_contigs_pmoA_cluster1.fa; done

for line in $(cat $WD/searchfile.txt); do usearch -cluster_fast $WD_Contig/mmoX/combined_contigs_mmoX.fa \
-id 0.8 -centroids $WD_Contig/mmoX/combined_contigs_mmoX_cluster1.fa; done


sed -i 's/>/>MFD_/' $WD_Contig/pmoA/combined_contigs_pmoA_cluster1.fa

sed -i 's/>/>MFD_/' $WD_Contig/mmoX/combined_contigs_mmoX_cluster1.fa

####And then blasting

module purge
module load DIAMOND/2.0.9-foss-2020b

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD_Contig/pmoA/combined_contigs_pmoA_cluster1.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD_Contig/pmoA/combined_pmoA_contig_balst_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads $THREADS

diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD_Contig/mmoX/combined_contigs_mmoX_cluster1.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD_Contig/mmoX/combined_mmoX_contig_balst_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads $THREADS

module purge

awk -F'\t' '{print $2" ,"$1}' $WD_Contig/mmoX/combined_mmoX_contig_balst_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1,[/;s/\].*$/\]/' | sed 's/ ,/,/'> $WD_Contig/mmoX/tax_file_mmoX_contig.csv

awk -F'\t' '{print $2" ,"$1}' $WD_Contig/pmoA/combined_pmoA_contig_balst_hits.txt \
| sed -E 's/^([^,]*),.*\[/\1,[/;s/\].*$/\]/'| sed 's/ ,/,/'> $WD_Contig/pmoA/tax_file_pmoA_contig.csv
