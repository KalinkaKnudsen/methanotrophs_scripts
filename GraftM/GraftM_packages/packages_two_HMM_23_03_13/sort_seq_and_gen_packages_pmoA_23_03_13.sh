#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages
cd $WD
odir_pmoA=$WD/packages_two_HMM_23_03_13/pmoA

old_pmoA=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22/contig_original_pmoA.fa
new_align_pmoA=$odir_pmoA/new_align_pmoA.fa
new_search_pmoA=$odir_pmoA/new_search_pmoA.fa
pmoA_seq_tax=/user_data/kalinka/GraftM/GraftM_packages/pmoA_contig_tree/GraftM_pmoA_contig_19_12_22/GraftM_pmoA_contig_19_12_22.refpkg/contig_original_pmoA_seqinfo.csv

##### Making a list of sequences to remove ####
grep -E 'Actinobacteria|HMO_cluster|Deltaproteobacteria_DHMO_cluster|Deltaproteobacteria_Binataceae_cluster|HMO_group_1|Nitrospira_clade_A|Nitrospira_clade_B|Betaproteobacteria_amoA|Homologous_perhaps_burkholderiales|perhaps_ethylene_cluster|Cycloclasticus_bradhyrhizobium_cluster|Cycloclasticus|Nitrosococcus' \
$pmoA_seq_tax | cut -d',' -f1 > $odir_pmoA/pmoA_seqs_to_remove.txt


#### Then I will use seqkit to remove these sequences from the "old" package
module load SeqKit/2.0.0
seqkit grep --invert-match -f $odir_pmoA/pmoA_seqs_to_remove.txt $old_pmoA > $odir_pmoA/old_search_pmoA_filtered.fa

## Then I want to add the new sequences to the search model ##
cat $odir_pmoA/old_search_pmoA_filtered.fa <(printf '\n') $new_search_pmoA > $odir_pmoA/search_pmoA_combined.fa

##Then create a search HMM model. First step is to make a MSA
module load MAFFT/7.490-GCC-10.2.0-with-extensions
mafft $odir_pmoA/search_pmoA_combined.fa > $odir_pmoA/search_pmoA_combined_MSA.fa

#### I am unsure if I should trim this or not.... For now, I will NOT trim it #####
module load HMMER/3.3.2-foss-2020b
hmmbuild --amino --cpu 10 $odir_pmoA/pmoA_search.hmm $odir_pmoA/search_pmoA_combined_MSA.fa


######### Then to the alignment model including all sequences #####
### Then, I want to make MSA of the alignment sequences. First combining the sequences, and then maft ###
cat $old_pmoA <(printf '\n') $new_search_pmoA <(printf '\n') $new_align_pmoA > $odir_pmoA/align_pmoA_combined.fa
mafft $odir_pmoA/align_pmoA_combined.fa > $odir_pmoA/align_pmoA_combined_MSA.fa

##### Here, I want to trim the MSA to 10/20% identity at a single position ####
module load TrimAl/1.4.1-foss-2020b
trimal -in $odir_pmoA/align_pmoA_combined_MSA.fa \
 -out $odir_pmoA/align_pmoA_combined_MSA_10pct.fa -gt 0.1
trimal -in $odir_pmoA/align_pmoA_combined_MSA.fa \
 -out $odir_pmoA/align_pmoA_combined_MSA_20pct.fa -gt 0.2

### Creating HMM
hmmbuild --amino --cpu 10 $odir_pmoA/pmoA_align.hmm $odir_pmoA/align_pmoA_combined_MSA_10pct.fa
hmmbuild --amino --cpu 10 $odir_pmoA/pmoA_align_20.hmm $odir_pmoA/align_pmoA_combined_MSA_20pct.fa

####### Generating a tree for this #####
module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $odir_pmoA/align_pmoA_combined_MSA_20pct.fa -m MFP -nt AUTO -B 1000 -T 10

###### Manual rerooting and grouping in ARB ####


###### Then, I need to create the graftM package ###
#The sequences provided must be all sequences
module purge
module load GraftM/0.14.0-foss-2020b
graftM create --sequences $odir_pmoA/align_pmoA_combined.fa --rerooted_annotated_tree $odir_pmoA/align_pmoA_combined.tree \
--hmm $odir_pmoA/pmoA_align_20.hmm --search_hmm $odir_pmoA/pmoA_search.hmm \
--output $odir_pmoA/pmoA_package_23_03_16 --log $odir_pmoA/graft_create.log --threads 20


### Generating a package with only 1 HMM;
graftM create --sequences $odir_pmoA/align_pmoA_combined.fa --rerooted_annotated_tree $odir_pmoA/align_pmoA_combined.tree \
--output $odir_pmoA/pmoA_package_23_04_18 --log $odir_pmoA/graft_create_23_04_18.log --threads 20