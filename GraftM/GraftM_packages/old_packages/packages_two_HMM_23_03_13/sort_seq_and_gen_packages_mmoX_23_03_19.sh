#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages
cd $WD
odir_mmoX=$WD/packages_two_HMM_23_03_13/mmoX

old_mmoX=/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/GraftM_mmoX_package_15_02_2023/combined_mmoX_seqs.fa
mmoX_seq_tax=/user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/GraftM_mmoX_package_15_02_2023/GraftM_mmoX_package_15_02_2023.refpkg/combined_mmoX_seqs_seqinfo.csv

##### Making a list of sequences to remove ####
grep -E 'Homologous_mmoX|Propane_monooxygenase|Actinomycetes|Butane_monooxygenase' \
$mmoX_seq_tax | cut -d',' -f1 > $odir_mmoX/mmoX_seqs_to_remove.txt


#### Then I will use seqkit to remove these sequences from the "old" package
module load SeqKit/2.0.0
seqkit grep --invert-match -f $odir_mmoX/mmoX_seqs_to_remove.txt $old_mmoX > $odir_mmoX/old_search_mmoX_filtered.fa

##Then create a search HMM model. First step is to make a MSA
module load MAFFT/7.490-GCC-10.2.0-with-extensions
mafft $odir_mmoX/old_search_mmoX_filtered.fa > $odir_mmoX/search_mmoX_MSA.fa

#### I am unsure if I should trim this or not.... For now, I will NOT trim it #####
module load HMMER/3.3.2-foss-2020b
hmmbuild --amino --cpu 10 $odir_mmoX/mmoX_search.hmm $odir_mmoX/search_mmoX_MSA.fa


######### Then to the alignment model including all sequences #####
### I already have the alignment and the tree from the old package. So I just need to update the HMMs

hmmbuild --amino --cpu 10 $odir_mmoX/mmoX_align_20.hmm /user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/combined_mmoX_seqs_aligned_20perc2.fa

### I already have an annotated tree ###


###### Then, I need to create the graftM package ###
#The sequences provided must be all sequences
module purge
module load GraftM/0.14.0-foss-2020b
graftM create --sequences $old_mmoX --rerooted_annotated_tree /user_data/kalinka/GraftM/GraftM_packages/mmoX_15_02_2023/mmoX_graftM_tree_15_02_2023.tree \
--hmm $odir_mmoX/mmoX_align_20.hmm --search_hmm $odir_mmoX/mmoX_search.hmm \
--output $odir_mmoX/mmoX_package_23_03_19 --log $odir_mmoX/graft_create.log --threads 20
