#!/bin/bash
WD=/user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes
cd $WD

MFD_long=/projects/microflora_danica/deep_metagenomes/assemblies

#Jeg kan jo bruge de filer jeg har lavet, og fjerne alle linjer der indeholder "Homologues_mmoX" og de andre text strings!


###group 7_7
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_group7_7.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /srv/MA/Projects/microflora_danica/group77/assembly.fasta > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/group7_7.fasta  -A 1

###MFD01138
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD01138.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD01138.fasta > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01138.fasta  -A 1

#####MFD01223
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD01223.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD01223.fasta > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01223.fasta  -A 1


#####MFD01248
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD01248.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD01248.fasta > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01248.fasta  -A 1


#####MFD02979
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD02979.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD02979.fasta\
 > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD02979.fasta  -A 1



#####MFD03346
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD03346.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD03346.fasta\
 > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD03346.fasta  -A 1



#####MFD03399
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD03399.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD03399.fasta\
 > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD03399.fasta  -A 1




#####MFD04434
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD04434.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD04434.fasta\
 > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD04434.fasta  -A 1


#####MFD05580
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD05580.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD05580.fasta\
 > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD05580.fasta  -A 1




#####MFD10064
cat /user_data/kalinka/GraftM/long_read_graftM/mfd_deep_metagenomes/cov_matched_MFD10064.txt\
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
| cut  -d ' ' -f 1 | uniq > temp1.tsv

grep -w -f temp1.tsv /projects/microflora_danica/deep_metagenomes/assemblies/MFD10064.fasta\
 > /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD10064.fasta  -A 1

rm temp1.tsv