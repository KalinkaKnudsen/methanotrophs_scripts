#!/bin/bash
module purge
module load prokka/1.14.5-gompi-2020b


prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/group7_7.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/group7_7_prokka \
--kingdom Bacteria

echo "First prokka is done"


prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01138.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01138_prokka \
--kingdom Bacteria 

prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01223.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01223_prokka \
--kingdom Bacteria 

prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01248.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD01248_prokka \
--kingdom Bacteria 

prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD02979.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD02979_prokka \
--kingdom Bacteria 

echo "Halfway there"

prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD03346.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD03346_prokka \
--kingdom Bacteria 

prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD03399.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD03399_prokka \
--kingdom Bacteria 

prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD04434.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD04434_prokka \
--kingdom Bacteria 

prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD05580.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD05580_prokka \
--kingdom Bacteria 

prokka --meta /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD10064.fasta \
--outdir /user_data/kalinka/GraftM/long_read_graftM/full_length_hits/MFD10064_prokka \
--kingdom Bacteria 

module purge

echo "Prokka done - have a nice day"