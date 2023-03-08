#!/bin/bash

#SBATCH --mem-per-cpu=4G
#SBATCH -c 1
#SBATCH --error=log/mafft_16s_tbas.err
#SBATCH --output=log/mafft_16s_tbas.out
#SBATCH --partition=scavenger

# MAFFT-Dash homologs on path
export PATH=$HOME/mafft-7.475-with-extensions/bin/:$PATH

# Align 16S seqs with mafft
mafft --globalpair --maxiterate 100 --thread 1 \
 analyses/tbas/seqs/16s.fna > \
 analyses/tbas/alignments/single/16s_aln.fna