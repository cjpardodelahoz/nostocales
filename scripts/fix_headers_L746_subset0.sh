#!/bin/bash

#SBATCH --array=1-746
#SBATCH --mem-per-cpu=1G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/fix_headers_L746_%A_%a.out
#SBATCH --error=log/fix_headers_L746_%A_%a.err
#SBATCH --partition=scavenger

locus=$(cat misc_files/L746.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)

sed -i 's/\s.*//' analyses/L746/alignments/single/${locus}_ng.faa
sed -i 's/\s.*//' analyses/L746/alignments/single/${locus}_ng.fna