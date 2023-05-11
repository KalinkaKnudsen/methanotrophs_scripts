#!/bin/bash
WD=/user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps
cd $WD

#I have done the filtering of the MAGS with hits in R. That was faster


#Now I want to copy all files from the searchfile into another file. So I want to get all the _orf.fa files
sed -i 's/\r$//' $WD/selected_genomes_pmoA.txt ##Because my files from R have weird windows endings
sed -i 's/_protein//' $WD/selected_genomes_pmoA.txt


#I want to copy the entire folder here in the first case
for line in $(cat $WD/selected_genomes_pmoA.txt); do
    cp -R $WD/pmoA/bacteria/graftm/"$line" $WD/pmoA_hits/ \
  | echo $line; done


sed -i 's/\r$//' $WD/selected_genomes_mmoX.txt ##Because my files from R have weird windows endings
sed -i 's/_protein//' $WD/selected_genomes_mmoX.txt


#I want to copy the entire folder here in the first case
for line in $(cat $WD/selected_genomes_mmoX.txt); do
    cp -R $WD/mmoX/bacteria/graftm/"$line" $WD/mmoX_hits/ \
  | echo $line; done


rm -r /user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/pmoA

echo "removed pmoA"
rm -r /user_data/kalinka/GraftM/gtdb_dereplicated/protein_faa_reps/mmoX
echo "removed mmoX"