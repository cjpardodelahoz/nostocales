#!/bin/bash

#SBATCH --mem-per-cpu=8G # adjust as needed
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L31_concat_guide.out
#SBATCH --error=log/L31_concat_guide.err
#SBATCH --partition=scavenger

# Load IQ-tree module
module load IQ-TREE/1.6.12
# Infer guide tree
iqtree -nt 8 -s analyses/L31/alignments/concat/aa/ng_concat.faa \
 -m LG+C20+F+G4 -pre analyses/L31/trees/concat/aa/ng_concat_guide