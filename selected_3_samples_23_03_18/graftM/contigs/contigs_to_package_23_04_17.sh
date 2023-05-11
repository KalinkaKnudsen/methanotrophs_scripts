#!/bin/bash

contigs=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs
cd $contigs

searchfile=/user_data/kalinka/selected_3_samples_23_03_18/graftM/contigs/searchfile.txt
module purge
module load SeqKit/2.0.0
module load DIAMOND/2.0.9-foss-2020b

for line in $(cat $searchfile); do
    cat $contigs/pmoA/graftm/$line/"$line"_assembly/"$line"_assembly_read_tax.tsv \
    | grep -w "Root;" \
    | grep -v "Root; Homologous_MO" \
    | awk '{print $1}' \
    | grep -f - $contigs/pmoA/graftm/$line/"$line"_assembly/"$line"_assembly.hmmout.txt \
    | awk '{ if ($3 > 240) {print $1}}' - \
    | seqkit grep -f - $contigs/pmoA/graftm/$line/"$line"_assembly/"$line"_assembly_orf.fa \
    | sed 's/>contig/>MFD_contig/' \
    >> $contigs/pmoA_contigs.fa
done


#### Obs filtered at 300 to add the Methylocapsa HQ sequence!
for line in $(cat $searchfile); do
    cat $contigs/mmoX/graftm/$line/"$line"_assembly/"$line"_assembly_read_tax.tsv \
    | grep -w "Root;" \
    | grep -v "Root; Homologous_mmoX" \
    | awk '{print $1}' \
    | grep -f - $contigs/mmoX/graftm/$line/"$line"_assembly/"$line"_assembly.hmmout.txt \
    | awk '{ if ($3 > 300) {print $1}}' - \
    | seqkit grep -f - $contigs/mmoX/graftm/$line/"$line"_assembly/"$line"_assembly_orf.fa \
    | sed 's/>contig/>MFD_contig/' \
    >> $contigs/mmoX_contigs.fa
done


##Clustering
usearch -cluster_fast $contigs/pmoA_contigs.fa \
-id 1 -centroids $contigs/pmoA_contigs_cluster1.fa &> $contigs/pmoA_cluster.log

usearch -cluster_fast $contigs/mmoX_contigs.fa \
-id 1 -centroids $contigs/mmoX_contigs_cluster1.fa &> $contigs/mmoX_cluster.log


##MSA
module load MAFFT/7.490-GCC-10.2.0-with-extensions
mafft $contigs/pmoA_contigs_cluster1.fa > $contigs/pmoA_contigs_align.fa
mafft $contigs/mmoX_contigs_cluster1.fa > $contigs/mmoX_contigs_align.fa

#### Hmm okay taking this to a new package update ###