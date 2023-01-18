#!/bin/bash

#SBATCH --array=1-31
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/trimal_L31_%A_%a.out
#SBATCH --error=log/trimal_L31_%A_%a.err
#SBATCH --partition=scavenger

# Triaml on path
export PATH=/hpc/group/bio1/carlos/apps/trimAl/source:${PATH}
# Variable with loci file names
locus=$(cat misc_files/L31.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Trim AA alignments
trimal -in analyses/L31/alignments/single/${locus}_aln.faa \
-out analyses/L31/alignments/single/${locus}_ng.faa \
-fasta -nogaps
# Trim NA alignments
trimal -in analyses/L31/alignments/single/${locus}_aln.fna \
-out analyses/L31/alignments/single/${locus}_ng.fna \
-fasta -nogaps