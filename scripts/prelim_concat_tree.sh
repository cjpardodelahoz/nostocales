#!/bin/bash

#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 16 # number of threads per process
#SBATCH --output=prelim_concat_tree.out
#SBATCH --error=prelim_concat_tree.err
#SBATCH --partition=common

# Load RAxML module
module load RAxML/8.2.12
# Direcotry for output
mkdir -p analyses/prelim/trees/concat
# Run RAxML
raxmlHPC-PTHREADS-SSE3 -T 16 -n concat_aa.tree \
 -s analyses/prelim/alignments/concat/concat_aa.phy \
 -c 25 -m PROTCATWAG -p 12345 -f a -N 1000 -x 12345 \
 --asc-corr lewis -w analyses/prelim/trees/concat