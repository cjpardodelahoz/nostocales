#!/bin/bash

#SBATCH --array=1-746
#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/L746_mafft.%A_%a.out
#SBATCH --error=log/L746_mafft.%A_%a.err
#SBATCH --partition=common

# MAFFT-Dash homologs on path
export PATH=$HOME/mafft-7.475-with-extensions/bin/:$PATH
# Load NCBI module (required)
module load NCBI-BLAST/2.7.1
# Variable with loci file names
locus=$(cat misc_files/L746.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Align aa seqs with mafft
mafft-homologs.rb -l -d misc_files/nostocales_busco_blastdb -w \
 -o '--dash --globalpair --maxiterate 100 --thread 1 --originalseqonly' \
 analyses/L746/seqs/${locus}.faa > \
 analyses/L746/alignments/single/${locus}_aln.faa