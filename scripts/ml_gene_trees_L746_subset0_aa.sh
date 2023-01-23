#!/bin/bash

#SBATCH --array=1-746
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 2 # number of threads per process
#SBATCH --output=log/ml_gene_trees_L746_subset0_ng_aa.%A_%a.out
#SBATCH --error=log/ml_gene_trees_L746_subset0_ng_aa.%A_%a.err
#SBATCH --partition=scavenger

# IQ-tree module
module load IQ-TREE/1.6.12
# Variable with loci file names
locus=$(cat misc_files/L746.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Run Iq-tree
iqtree -nt 2 \
 -pre analyses/L746/trees/single/aa/${locus}_ng \
 -s analyses/L746/alignments/single/${locus}_ng.faa \
 -m MFP -madd $(< misc_files/madd) -bb 1000 -bnni
