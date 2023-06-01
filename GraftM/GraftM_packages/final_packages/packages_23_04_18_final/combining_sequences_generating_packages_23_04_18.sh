#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages/packages_23_04_18
cd $WD
mkdir $WD/pmoA
odir_pmoA=$WD/pmoA

old_pmoA=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/pmoA/pmoA_package_23_03_16/align_pmoA_combined.fa
contigs=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/pmoA_contigs_cluster1.fa
amoA=$odir_pmoA/amoa.fa


######### Then to the alignment model including all sequences #####
### Then, I want to make MSA of the alignment sequences. First combining the sequences, and then maft ###
cat $old_pmoA <(printf '\n') $contigs <(printf '\n') $amoA > $odir_pmoA/pmoA_combined.fa


###Dereplicating ###

usearch -cluster_fast  $odir_pmoA/pmoA_combined.fa \
-id 1 -centroids  $odir_pmoA/pmoA_combined_cluster1.fa &>  $odir_pmoA/pmoA_cluster.log


module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $odir_pmoA/pmoA_combined_cluster1.fa > $odir_pmoA/pmoA_combined_MSA.fa

##### Here, I want to trim the MSA to 20% identity at a single position ####
module load TrimAl/1.4.1-foss-2020b
trimal -in $odir_pmoA/pmoA_combined_MSA.fa \
 -out $odir_pmoA/pmoA_combined_MSA_20pct.fa -gt 0.2


##### Evaluating the sequences in CLC #####
## Removing MFD_contig_48620_3390_6_94 (Deltaproteobacteria) too short (or at least looks funky in alignment)
## Removing MFD_contig_60278_62124_6_941 (Methylocystaceae pmoA1) - blasts to AmoA superfamily
## Keeping Ga0039977_1192_1_2600255026, Betaproteobacteria_amoA  
## Removing MFD_contig_177712_16862_5_288 (pmoB sequence)
## Removing MFD_contig_148665_197_2_18 (Aligned to pmoA2, but has high seq_ID to amoA)

#### Then I will use seqkit to remove these sequences from the package
module load SeqKit/2.0.0

cat $odir_pmoA/pmoA_combined_cluster1.fa | seqkit grep - --invert-match -p "MFD_contig_48620_3390_6_94"  \
| seqkit grep - --invert-match -p "MFD_contig_60278_62124_6_941" \
| seqkit grep - --invert-match -p "MFD_contig_177712_16862_5_288" \
| seqkit grep - --invert-match -p "MFD_contig_148665_197_2_18" \
 > $odir_pmoA/pmoA_combined_cluster1_revised.fa


mafft $odir_pmoA/pmoA_combined_cluster1_revised.fa > $odir_pmoA/pmoA_combined_MSA_revised.fa

##### Here, I want to trim the MSA to 20% identity at a single position ####
module load TrimAl/1.4.1-foss-2020b
trimal -in $odir_pmoA/pmoA_combined_MSA_revised.fa \
 -out $odir_pmoA/pmoA_combined_MSA_revised_20pct.fa -gt 0.2

####### Generating a tree for this #####
module load IQ-TREE/2.1.2-gompi-2020b


iqtree2 -s $odir_pmoA/pmoA_combined_MSA_revised_20pct.fa -m MFP -nt AUTO -B 1000 -T 20 -redo

###### Manual rerooting and grouping in ARB ####


###### Then, I need to create the graftM package ###
#The sequences provided must be all sequences
module purge
module load GraftM/0.14.0-foss-2020b

### Generating a package with only 1 HMM;
graftM create --sequences $odir_pmoA/pmoA_combined_cluster1_revised.fa --rerooted_annotated_tree $odir_pmoA/pmoA_tree_for_package.tree \
--output $WD/pmoA_GraftM_23_04_18 --log $odir_pmoA/graft_create_23_04_18.log --threads 20 --verbosity 5


########### Now to mmoX ############


old_mmoX=/user_data/kalinka/GraftM/GraftM_packages/packages_two_HMM_23_03_13/mmoX/mmoX_package_23_03_19/combined_mmoX_seqs.fa
contigs_mmoX=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/mmoX_contigs_cluster1.fa

mkdir $WD/mmoX
odir_mmoX=$WD/mmoX

######### Then to the alignment model including all sequences #####
### Then, I want to make MSA of the alignment sequences. First combining the sequences, and then maft ###
cat $old_mmoX <(printf '\n') $contigs_mmoX <(printf '\n') > $odir_mmoX/mmoX_combined.fa


###Dereplicating ###

usearch -cluster_fast  $odir_mmoX/mmoX_combined.fa \
-id 1 -centroids  $odir_mmoX/mmoX_combined_cluster1.fa &>  $odir_mmoX/mmoX_cluster.log


module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $odir_mmoX/mmoX_combined_cluster1.fa > $odir_mmoX/mmoX_combined_MSA.fa

##### Here, I want to trim the MSA to 20% identity at a single position ####
module load TrimAl/1.4.1-foss-2020b
trimal -in $odir_mmoX/mmoX_combined_MSA.fa \
 -out $odir_mmoX/mmoX_combined_MSA_20pct.fa -gt 0.2


##### Evaluating the sequences in CLC #####
#### Nothing to remove from the mmoX!


####### Generating a tree for this #####
module load IQ-TREE/2.1.2-gompi-2020b


iqtree2 -s $odir_mmoX/mmoX_combined_MSA_20pct.fa -m MFP -nt AUTO -B 1000 -T 10

###### Manual rerooting and grouping in ARB ####


### Generating the GraftM packages. I will not create 1 for search and 1 for alignment. I will just use graftM build in function ###

### Generating a package with only 1 HMM;
graftM create --sequences $odir_mmoX/mmoX_combined_cluster1.fa --rerooted_annotated_tree $odir_mmoX/mmoX_tree_for_package.tree \
--output $WD/mmoX_GraftM_23_04_18 --log $odir_mmoX/graft_create_23_04_18.log --threads 20