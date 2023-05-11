#!/bin/bash
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/raw_reads
cd $WD


for line in $(cat $WD/searchfile.txt); do cat $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_read_tax.tsv\
| grep -e "Root;"\
| grep -v "Root; Homologues_mmoX" \
| grep -v "Root; HMO_cluster" \
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pxmA_amoA; amoA; Betaproteobacteria_amoA" \
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pxmA_amoA; amoA" \
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pxmA_amoA; amoA; Nitrospira_clade_B"\
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pxmA_amoA; amoA; Nitrospira_clade_A" \
| grep -v "Root; HMO_cluster; DHMO"\
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pmoA; Nitrosococcus" \
| grep -v "Root; Actinobacteria"\
| grep -v "Root; HMO_cluster; HMO_group_1"\
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pmoA; TUSC_NC10_cycloclasticus_cluster; Cycloclasticus"\
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_tax_filtered.tsv;\
done

####Now I need to extract the lines from the HMM-out, that match the reads of the tax_filtered file
for line in $(cat $WD/searchfile.txt); do head -n 3 $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt.hmmout.txt \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
| awk 'FNR==NR {arr[$1];next} $1 in arr' $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_tax_filtered.tsv \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt.hmmout.txt \
>> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
| echo $line; done


##Now making subsets for the longer reads
#I also only want reads that span more than 100, I will see If I can make that happen
for line in $(cat $WD/searchfile.txt); do awk '{ if ($3 > 240 && $17 - $16 >100) {print ">"$1}}'  $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_longer_200.hmmout.txt; done

#And extracting the MSA and also the coding sequences!
for line in $(cat $WD/searchfile.txt); do grep -A1 -wf $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_longer_200.hmmout.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.aln.fa \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_alignment_longer_200.aln.fa \
| echo $line; done

for line in $(cat $WD/searchfile.txt); do grep -A1 -wf $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_longer_200.hmmout.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_orf.fa | sed 's/--//' \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_orf_long.aln.fa \
| echo $line; done

##Now I want to subset the short reads and their alignments However, Here I want all the info so I want to remove the _number_number
for line in $(cat $WD/searchfile.txt); do awk '{ if ($3 < 240) {print ">"$1}}' $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
| sed 's/\(_*_*_\)\S*//' > $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_shorter_200.hmmout.txt; done

#And extracting the MSA
for line in $(cat $WD/searchfile.txt); do grep -A1 -f $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_shorter_200.hmmout.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.aln.fa \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_alignment_shorter_200.aln.fa \
| echo $line; done

#And now, I want to extract the too short nucleotide sequences;

#First I need to remove the enters - that messes up with the grep, so I remove enters with awk;
for line in $(cat $WD/searchfile.txt); do awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.fa \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits_temp.fa \
| echo $line; done

###And now to the grep!
for line in $(cat $WD/searchfile.txt); do grep -A1 -f $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_shorter_200.hmmout.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits_temp.fa | sed 's/--//' \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences.fa \
| echo $line; done

########### Now to the proveframe correction of the too short reads!
module purge
module load DIAMOND/2.0.9-foss-2020b

for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t 30 -d \
/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/pmoA_sequences.dmnd \
-o $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line".tsv $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences.fa -- -c1; done


##Then, I will edit the sequences
for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
-o $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_corrected.fa \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences.fa \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line".tsv; done


###Translation to CDS's
module purge
module load OrfM/0.7.1-foss-2020b

for line in $(cat $WD/searchfile.txt); do orfm $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_corrected.fa \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS.fa; done

###Hmmm Okay, but now I want to try and just filter the CDS file;
for line in $(cat $WD/searchfile.txt); do cat $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS.fa \
| awk '{y= i++ % 2 ; L[y]=$0; if(y==1 && length(L[1])>=230) {printf("%s\n%s\n",L[0],L[1]);}}' \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS_longer_240.fa; done



###And now trying to do HMMscan
module purge
module load HMMER/3.3.2-foss-2020b

#I am setting the E-value to 0.0001 to ensure that I only get the hits that I want!
for line in $(cat $WD/searchfile.txt); do hmmsearch -E 0.0001 --domtblout \
/$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_hmmout.txt \
/user_data/kalinka/GraftM/GraftM_packages/pmoA_final/pmoA_graftM_package_24_10_2022/graftmdica0r27_search.hmm \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS_longer_240.fa; done

module purge

#Now I want to extract the sequences that hit in the HMM from the CDS_file. 
for line in $(cat $WD/searchfile.txt); do  awk '{ if ($3 > 240 && $17 - $16 >100) {print ">"$1}}' \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_hmmout.txt > $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_temp1.txt; done

for line in $(cat $WD/searchfile.txt); do grep -A1 -wf $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_temp1.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS_longer_240.fa \
| sed 's/--//' > $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_corrected_short_hits.fa; done

##Removing unwanted and temp files;
for line in $(cat $WD/searchfile.txt); do rm $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_temp1.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_tax_filtered.tsv \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_longer_200.hmmout.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_shorter_200.hmmout.txt \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits_temp.fa \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences.fa \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line".tsv \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS.fa; done


###Now appending the two files, and deduplicating them;
for line in $(cat $WD/searchfile.txt); do cat \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_corrected_short_hits.fa \
$WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_orf_long.aln.fa \
> $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_long_sequences.fa; done

#for line in $(cat $WD/searchfile.txt); do usearch -cluster_fast $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_long_sequences.fa \
#-id 1 -centroids $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_deduplicated_long_sequences.fa; done

###Perhaps 80% is pretty good?
for line in $(cat $WD/searchfile.txt); do usearch -cluster_fast $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_long_sequences.fa \
-id 0.8 -centroids $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_deduplicated_95_long_sequences.fa; done

###For fun I want to contencate everything and try to re-cluster that!
rm $WD/pmoA/combined_long_sequences.fa

for line in $(cat $WD/searchfile.txt); do cat $WD/pmoA/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_deduplicated_95_long_sequences.fa \
>> $WD/pmoA/combined_long_sequences.fa;done

##Okay når jeg cluster ved 80% ender jeg alligevel på 904 pmoA sekvenser.... Måske jeg skal prøve at blaste dem?
usearch -cluster_fast $WD/pmoA/combined_long_sequences.fa \
-id 0.8 -centroids $WD/pmoA/combined_long_sequences_deduplicated.fa





#################################### mmoX #########################################



for line in $(cat $WD/searchfile.txt); do cat $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_read_tax.tsv\
| grep -e "Root;"\
| grep -v "Root; Homologues_mmoX" \
| grep -v "Root; HMO_cluster" \
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pxmA_amoA; amoA; Betaproteobacteria_amoA" \
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pxmA_amoA; amoA" \
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pxmA_amoA; amoA; Nitrospira_clade_B"\
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pxmA_amoA; amoA; Nitrospira_clade_A" \
| grep -v "Root; HMO_cluster; DHMO"\
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pmoA; Nitrosococcus" \
| grep -v "Root; Actinobacteria"\
| grep -v "Root; HMO_cluster; HMO_group_1"\
| grep -v "Root; pmoA_amoA_pxmA_umbrella; pmoA; TUSC_NC10_cycloclasticus_cluster; Cycloclasticus"\
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_tax_filtered.tsv;\
done

####Now I need to extract the lines from the HMM-out, that match the reads of the tax_filtered file
for line in $(cat $WD/searchfile.txt); do head -n 3 $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt.hmmout.txt \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
| awk 'FNR==NR {arr[$1];next} $1 in arr' $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_tax_filtered.tsv \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt.hmmout.txt \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
| echo $line; done


##Now making subsets for the longer reads
#I also only want reads that span more than 100, I will see If I can make that happen
for line in $(cat $WD/searchfile.txt); do awk '{ if ($3 > 400 && $17 - $16 >100) {print ">"$1}}'  $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_longer_400.hmmout.txt; done

#And extracting the MSA and also the coding sequences!
for line in $(cat $WD/searchfile.txt); do grep -A1 -wf $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_longer_400.hmmout.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.aln.fa \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_alignment_longer_400.aln.fa \
| echo $line; done

for line in $(cat $WD/searchfile.txt); do grep -A1 -wf $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_longer_400.hmmout.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_orf.fa | sed 's/--//' \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_orf_long.aln.fa \
| echo $line; done

##Now I want to subset the short reads and their alignments However, Here I want all the info so I want to remove the _number_number
for line in $(cat $WD/searchfile.txt); do awk '{ if ($3 < 400) {print ">"$1}}' $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
| sed 's/\(_*_*_\)\S*//' > $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_shorter_400.hmmout.txt; done

#And extracting the MSA
for line in $(cat $WD/searchfile.txt); do grep -A1 -f $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_shorter_400.hmmout.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.aln.fa \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_alignment_shorter_400.aln.fa \
| echo $line; done

#And now, I want to extract the too short nucleotide sequences;

#First I need to remove the enters - that messes up with the grep, so I remove enters with awk;
for line in $(cat $WD/searchfile.txt); do awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.fa \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits_temp.fa \
| echo $line; done

###And now to the grep!
for line in $(cat $WD/searchfile.txt); do grep -A1 -f $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_shorter_400.hmmout.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits_temp.fa | sed 's/--//' \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences.fa \
| echo $line; done

########### Now to the proveframe correction of the too short reads!
module purge
module load DIAMOND/2.0.9-foss-2020b

for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t 30 -d \
/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.dmnd \
-o $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line".tsv $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences.fa -- -c1; done

#for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe map -t 10 -d \
#/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/mmoX_sequences.dmnd \
#-o $WD/proovframe/mmoX/"$line".tsv $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.fa -- -c1; done

##Then, I will edit the sequences
for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
-o $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_corrected.fa \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences.fa \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line".tsv; done

#for line in $(cat $WD/searchfile.txt); do $WD/proovframe/proovframe/bin/proovframe fix \
#-o $WD/proovframe/mmoX/"$line"_corrected.fa $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits.fa \
#$WD/proovframe/mmoX/"$line".tsv; done

###Translation to CDS's
module purge
module load OrfM/0.7.1-foss-2020b

for line in $(cat $WD/searchfile.txt); do orfm $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_corrected.fa \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS.fa; done

###Hmmm Okay, but now I want to try and just filter the CDS file;
for line in $(cat $WD/searchfile.txt); do cat $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS.fa \
| awk '{y= i++ % 2 ; L[y]=$0; if(y==1 && length(L[1])>=400) {printf("%s\n%s\n",L[0],L[1]);}}' \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS_longer_400.fa; done



###And now trying to do HMMscan
module purge
module load HMMER/3.3.2-foss-2020b

#I am setting the E-value to 0.0001 to ensure that I only get the hits that I want!
for line in $(cat $WD/searchfile.txt); do hmmsearch -E 0.0001 --domtblout \
/$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_hmmout.txt \
/user_data/kalinka/GraftM/GraftM_packages/mmoX_final/graftM_mmoX_01_11_2022/graftmn0ssxnot_search.hmm \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS_longer_400.fa; done

module purge

#Now I want to extract the sequences that hit in the HMM from the CDS_file. 
for line in $(cat $WD/searchfile.txt); do  awk '{ if ($3 > 400 && $17 - $16 >100) {print ">"$1}}' \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_hmmout.txt > $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_temp1.txt; done

for line in $(cat $WD/searchfile.txt); do grep -A1 -wf $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_temp1.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS_longer_400.fa \
| sed 's/--//' > $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_corrected_short_hits.fa; done

##Removing unwanted and temp files;
for line in $(cat $WD/searchfile.txt); do rm $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_temp1.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_tax_filtered.tsv \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered.hmmout.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_longer_400.hmmout.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_filtered_shorter_400.hmmout.txt \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_R1041_trim_filt_hits_temp.fa \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences.fa \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line".tsv \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_short_sequences_CDS.fa; done


###Now appending the two files, and deduplicating them;
for line in $(cat $WD/searchfile.txt); do cat \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_corrected_short_hits.fa \
$WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_orf_long.aln.fa \
> $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_long_sequences.fa; done

#### I cluster at 80% here also!
for line in $(cat $WD/searchfile.txt); do usearch -cluster_fast $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_long_sequences.fa \
-id 0.8 -centroids $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_deduplicated_long_sequences.fa; done

###For fun I want to contencate everything and try to re-cluster that!
rm $WD/mmoX/combined_long_sequences.fa

for line in $(cat $WD/searchfile.txt); do cat $WD/mmoX/graftm/$line/"$line"_R1041_trim_filt/"$line"_combined_deduplicated_long_sequences.fa \
>> $WD/mmoX/combined_long_sequences.fa;done

##Clustering at 80% gives me 649 mmoX sequences. I will also like to blast those!
usearch -cluster_fast $WD/mmoX/combined_long_sequences.fa \
-id 0.8 -centroids $WD/mmoX/combined_long_sequences_deduplicated.fa

