#!/bin/bash

#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 16 # number of threads per process
#SBATCH --output=log/L1082_concat_pf_ngmin_na.out
#SBATCH --error=log/L1082_concat_pf_ngmin_na.err
#SBATCH --partition=scavenger

# IQ-tree module
module load IQ-TREE/1.6.12
# Run partition finder within IQ-tree
iqtree -nt 16 -s analyses/ngmin/alignments/concat/na/ngmin_concat.fna \
 -spp analyses/ngmin/alignments/concat/na/ngmin_na_Cpart \
 -m MF+MERGE -rclusterf 10 -rcluster-max 100 \
 -pre analyses/ngmin/trees/concat/na/ngmin_concat