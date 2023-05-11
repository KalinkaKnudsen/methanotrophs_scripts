#!/bin/bash

WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/
cd $WD

module purge
module load DIAMOND/2.0.9-foss-2020b

##First I need to remove the "false" hits
for line in $(cat $WD/searchfile1.txt); do cat $WD/pmoA/graftm/$line/"$line"/"$line"_read_tax.tsv\
| grep -e "Root;*"\
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
| awk '{print $1}'> $WD/pmoA/graftm/$line/"$line"/"$line"_tax_filtered.tsv;\
done

for line in $(cat $WD/searchfile1.txt); do cat $WD/mmoX/graftm/$line/"$line"/"$line"_read_tax.tsv\
| grep -e "Root;*"\
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
| awk '{print $1}'> $WD/mmoX/graftm/$line/"$line"/"$line"_tax_filtered.tsv;\
done

###Then I need to extract those sequences from the orf file;

for line in $(cat $WD/searchfile1.txt); do grep -A1 -f $WD/pmoA/graftm/$line/"$line"/"$line"_tax_filtered.tsv \
$WD/pmoA/graftm/$line/"$line"/"$line"_orf.fa \
> $WD/pmoA/graftm/$line/"$line"/"$line"_orf_positives.fa \
| echo $line; done

for line in $(cat $WD/searchfile1.txt); do grep -A1 -f $WD/mmoX/graftm/$line/"$line"/"$line"_tax_filtered.tsv \
$WD/mmoX/graftm/$line/"$line"/"$line"_orf.fa \
> $WD/mmoX/graftm/$line/"$line"/"$line"_orf_positives.fa \
| echo $line; done

for line in $(cat $WD/searchfile1.txt); do diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD/pmoA/graftm/$line/"$line"/"$line"_orf_positives.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD/pmoA/graftm/$line/$line/"$line"_blast_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 20; done

for line in $(cat $WD/searchfile1.txt); do diamond blastp --db /user_data/kalinka/nr.dmnd \
-q $WD/mmoX/graftm/$line/$line/"$line"_orf_positives.fa \
-f 6 salltitles qseqid sseqid pident length mismatch qstart qend evalue bitscore slen sstart send gaps \
-o $WD/mmoX/graftm/$line/$line/"$line"_blast_hits.txt --max-target-seqs 1 -b12 -c1 -t /user_data/kalinka/temp --threads 20; done

module purge