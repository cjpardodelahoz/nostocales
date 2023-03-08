#!/bin/bash

#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/ml_16s.out
#SBATCH --error=log/ml_16s.err
#SBATCH --partition=scavenger

# Iqtree module
module load IQ-TREE/1.6.12
# Directory for tree
mkdir -p analyses/tbas/trees/16s
# 16s tree
iqtree -nt 1 -pre analyses/tbas/trees/single/16s \
-s analyses/tbas/alignments/single/16s_aln.fna \
-m MFP -bb 1000 -bnni -safe