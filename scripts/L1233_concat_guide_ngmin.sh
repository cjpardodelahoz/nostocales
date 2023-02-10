#!/bin/bash

#SBATCH --mem-per-cpu=8G # adjust as needed
#SBATCH -c 48 # number of threads per process
#SBATCH --output=log/L1233_concat_guide.out
#SBATCH --error=log/L1233_concat_guide.err
#SBATCH --partition=scavenger

# Load IQ-tree module
module load IQ-TREE/1.6.12
# Infer guide tree
iqtree -nt 48 -s analyses/ngmin/alignments/concat/aa/ngmin_concat.faa \
 -m LG+C20+F+G4 -pre analyses/ngmin/trees/concat/aa/ngmin_concat_guide