#!/bin/bash

#SBATCH --array=1-1293
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/pb_c1_%A_%a.out
#SBATCH --error=log/pb_c1_%A_%a.err
#SBATCH --partition=common

# Phylobayes Path
export PATH=/hpc/home/cjp47/phylobayes/data:$PATH
# Variable with files with locus-specifc commands
locus_command=$(ls analyses/phylonetworks/alignments/*c1.pb | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Run Phylobayes
pb $(cat ${locus_command})