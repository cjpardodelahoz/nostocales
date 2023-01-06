#!/bin/bash

#SBATCH --array=1-773
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/mafft_all_cyanodb10_aa_%A_%a.out
#SBATCH --error=log/mafft_all_cyanodb10_aa_%A_%a.err
#SBATCH --partition=scavenger

# Path to mafft
export PATH=/hpc/home/cjp47/mafft-7.475-with-extensions/bin:${PATH}
# Variable with busco ids
seq=$(cat misc_files/busco_ids_cyanodb10.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Create output directories
mkdir -p analyses/prelim/alignments/single
# Run mafft with default parameters
mafft analyses/prelim/seqs/${seq}.faa > \
analyses/prelim/alignments/single/${seq}_aln.faa