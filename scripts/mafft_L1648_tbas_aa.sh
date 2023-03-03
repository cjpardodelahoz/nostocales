#!/bin/bash

#SBATCH --array=1-1648%5
#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/L1648_mafft_tbas.%A_%a.out
#SBATCH --error=log/L1648_mafft_tbas.%A_%a.err
#SBATCH --partition=common

# MAFFT-Dash homologs on path
export PATH=$HOME/mafft-7.475-with-extensions/bin/:$PATH
# Load NCBI module (required)
module load NCBI-BLAST/2.7.1
# Variable with loci file names
locus=$(cat misc_files/L1648.txt.bak | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Align aa seqs with mafft
mafft-homologs.rb -l -d databases/nostocales_busco_blastdb -w \
 -o '--dash --globalpair --maxiterate 100 --thread 1 --originalseqonly' \
 analyses/tbas/seqs/${locus}.faa > \
 analyses/tbas/alignments/single/${locus}_aln.faa