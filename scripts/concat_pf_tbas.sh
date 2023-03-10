#!/bin/bash

#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 12 # number of threads per process
#SBATCH --output=log/concat_pf_tbas.out
#SBATCH --error=log/concat_pf_tbas.err
#SBATCH --partition=common

# Iqtree module
module load IQ-TREE/1.6.12
# Directory for tree output
mkdir -p analyses/tbas/trees/concat
# Find best partition scheme
iqtree -nt 12 -s analyses/tbas/alignments/concat/concat_ng.fna \
 -m MF+MERGE -rclusterf 10 -rcluster-max 100 \
 -spp analyses/tbas/alignments/concat/codon_partition_concat_ng_na \
 -pre analyses/tbas/trees/concat/concat_pf_ng_na