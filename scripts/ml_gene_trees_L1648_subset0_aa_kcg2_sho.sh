#!/bin/bash

#SBATCH --array=1-1648
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 2 # number of threads per process
#SBATCH --output=log/ml_gene_trees_L1648_subset0_aa_kcg2_sho.%A_%a.out
#SBATCH --error=log/ml_gene_trees_L1648_subset0_aa_kcg2_sho.%A_%a.err
#SBATCH --partition=scavenger

# IQ-tree module
module load IQ-TREE/1.6.12
# Variable with loci file names
locus=$(cat misc_files/L1648.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Run Iq-tree
iqtree -nt 2 \
 -pre analyses/L1648/trees/single/kcg2/aa/${locus}_kcg2_sho \
 -s analyses/L1648/alignments/single/${locus}_kcg2.faa \
 -m MFP -bb 1000 -bnni
