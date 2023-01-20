#!/bin/bash

#SBATCH --array=1-70
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 2 # number of threads per process
#SBATCH --output=log/ml_gene_trees_L70_subset0_ng_na.%A_%a.out
#SBATCH --error=log/ml_gene_trees_L70_subset0_ng_na.%A_%a.err
#SBATCH --partition=scavenger

# IQ-tree module
module load IQ-TREE/1.6.12
# Variable with loci file names
locus=$(cat misc_files/L70.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Run Iq-tree
iqtree -nt 2 \
 -pre analyses/L70/trees/single/na/${locus}_ng \
 -s analyses/L70/alignments/single/${locus}_ng.fna \
 -spp analyses/L70/alignments/single/${locus}_ng_Cpart \
 -m MFP+MERGE -bb 1000 -bnni
