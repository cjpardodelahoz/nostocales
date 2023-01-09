#!/bin/bash

#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 16 # number of threads per process
#SBATCH --output=log/prelim_concat_tree.out
#SBATCH --error=log/prelim_concat_tree.err
#SBATCH --partition=common

# Path to wd. Replace with the path where you have the nostocales project dir
# This is because RAxML doesn't like relative paths
wd="/hpc/group/bio1/nostocales"
# Load RAxML module
module load RAxML/8.2.12
# Direcotry for output
mkdir -p analyses/prelim/trees/concat
# Run RAxML
raxmlHPC-PTHREADS-SSE3 -T 16 -n concat_aa.tree \
 -s analyses/prelim/alignments/concat/concat_aa.phy \
 -c 25 -m PROTCATWAG -p 12345 -f a -N 1000 -x 12345 \
 --asc-corr lewis -w ${wd}/analyses/prelim/trees/concat