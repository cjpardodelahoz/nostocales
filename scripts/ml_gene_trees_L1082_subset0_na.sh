#!/bin/bash

#SBATCH --array=1-1082
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 2 # number of threads per process
#SBATCH --output=log/ml_gene_trees_L1082_subset0_ngmin_na.%A_%a.out
#SBATCH --error=log/ml_gene_trees_L1082_subset0_ngmin_na.%A_%a.err
#SBATCH --partition=scavenger

# IQ-tree module
module load IQ-TREE/1.6.12
# Variable with loci file names
locus=$(cat misc_files/L1082.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Run Iq-tree
iqtree -nt 2 \
 -pre analyses/ngmin/trees/single/na/${locus}_selected_55_ngmin \
 -s analyses/ngmin/alignments/single/${locus}_selected_55_ngmin.fna \
 -m MFP -madd $(< misc_files/madd) -bb 1000 -bnni
