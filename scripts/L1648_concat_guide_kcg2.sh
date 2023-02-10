#!/bin/bash

#SBATCH --mem-per-cpu=10G # adjust as needed
#SBATCH -c 64 # number of threads per process
#SBATCH --output=log/L1648_concat_guide_kcg2.out
#SBATCH --error=log/L1648_concat_guide_kcg2.err
#SBATCH --partition=scavenger

# Load IQ-tree module
module load IQ-TREE/1.6.12
# Infer guide tree
iqtree -nt 64 -s analyses/L1648/alignments/concat/kcg2/aa/kcg2_concat.faa \
 -m LG+C20+F+G4 -pre analyses/L1648/trees/concat/kcg2/aa/kcg2_concat_guide