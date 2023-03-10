#!/bin/bash

#SBATCH --array=1-1649
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/trimal_tbas_%A_%a.out
#SBATCH --error=log/trimal_tbas_%A_%a.err
#SBATCH --partition=scavenger

# Triaml on path
export PATH=/hpc/group/bio1/carlos/apps/trimAl/source:${PATH}
# Variable with loci file names
locus=$(cat misc_files/tbas_loci.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Trim NA alignments
trimal -in analyses/tbas/alignments/single/${locus}_aln.fna \
-out analyses/tbas/alignments/single/${locus}_ng.fna \
-fasta -nogaps
# Trim AA alignments
trimal -in analyses/tbas/alignments/single/${locus}_aln.faa \
-out analyses/tbas/alignments/single/${locus}_ng.faa \
-fasta -nogaps
