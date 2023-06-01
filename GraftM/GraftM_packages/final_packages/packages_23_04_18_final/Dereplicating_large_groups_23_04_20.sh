#!/bin/bash

WD=/user_data/kalinka/GraftM/GraftM_packages/packages_23_04_18
cd $WD
odir_pmoA=$WD/pmoA

module load SeqKit/2.0.0

######### Extracting Methylococcaceae_pmoA (68 -> 46) Methylocystaceae_pmoA1 (38 -> 19) Alphaproteobacteria_pxmA (42 -> 23) and Homologous Binatales (30 -> 23) ##########

##### I also want to remove 
##### I want to remove >MFD_contig_38118_282_3_46 (amoA) >MFD_contig_15761_15848_5_331 (amoA) ####
grep -E "Methylococcaceae_pmoA|Methylocystaceae_pmoA1|Homologous_Binatales|Alphaproteobacteria_pxmA" \
$WD/pmoA_GraftM_23_04_18/pmoA_GraftM_23_04_18.refpkg/pmoA_combined_cluster1_revised_seqinfo.csv \
| cut -d , -f 1 | grep -Ev "MFD_contig_38118_282_3_46|MFD_contig_15761_15848_5_331" | seqkit grep -f - $WD/pmoA_GraftM_23_04_18/pmoA_combined_cluster1_revised.fa \
> $odir_pmoA/M_M_DHMO_pxm.fa


usearch -cluster_fast $odir_pmoA/M_M_DHMO_pxm.fa -id 0.97 \
-centroids $odir_pmoA/M_M_DHMO_pxm_derep.fa &>  $odir_pmoA/M_M_DHMO_pxm_derep.log

###### Then, I need to concatenate the old sequence file (without the dereplicated sequences) with the new files ###
grep -vE "Methylococcaceae_pmoA|Methylocystaceae_pmoA1|Homologous_Binatales|Alphaproteobacteria_pxmA" \
$WD/pmoA_GraftM_23_04_18/pmoA_GraftM_23_04_18.refpkg/pmoA_combined_cluster1_revised_seqinfo.csv \
| cut -d , -f 1 | seqkit grep -f - $WD/pmoA_GraftM_23_04_18/pmoA_combined_cluster1_revised.fa \
> $odir_pmoA/pmoA_combined_M_M_DHMO_pxm_derep.fa

cat $odir_pmoA/M_M_DHMO_pxm_derep.fa >> $odir_pmoA/pmoA_combined_M_M_DHMO_pxm_derep.fa


module load MAFFT/7.490-GCC-10.2.0-with-extensions

mafft $odir_pmoA/pmoA_combined_M_M_DHMO_pxm_derep.fa > $odir_pmoA/pmoA_combined_M_M_DHMO_pxm_derep_MSA.fa

##### Here, I want to trim the MSA to 20% identity at a single position ####
module load TrimAl/1.4.1-foss-2020b
trimal -in $odir_pmoA/pmoA_combined_M_M_DHMO_pxm_derep_MSA.fa \
 -out $odir_pmoA/pmoA_combined_M_M_DHMO_pxm_derep_MSA_20.fa -gt 0.2


####### Generating a tree for this #####
module load IQ-TREE/2.1.2-gompi-2020b

iqtree2 -s $odir_pmoA/pmoA_combined_M_M_DHMO_pxm_derep_MSA_20.fa -m MFP -nt AUTO -B 1000 -T 20 -redo

###### Manual rerooting and grouping in ARB ####


###### Then, I need to create the graftM package ###
#The sequences provided must be all sequences
module purge
module load GraftM/0.14.0-foss-2020b

### Generating a package with only 1 HMM;
graftM create --sequences $odir_pmoA/pmoA_combined_M_M_DHMO_pxm_derep.fa --rerooted_annotated_tree $odir_pmoA/pmoA_tree_for_package_derep.tree \
--output $WD/pmoA_GraftM_23_04_21 --log $odir_pmoA/graft_create_23_04_21.log --threads 20 --verbosity 5
