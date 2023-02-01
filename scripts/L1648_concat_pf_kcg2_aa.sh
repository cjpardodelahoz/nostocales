#!/bin/bash

#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 16 # number of threads per process
#SBATCH --output=log/L1648_concat_pf_kcg2_aa.out
#SBATCH --error=log/L1648_concat_pf_kcg2_aa.err
#SBATCH --partition=scavenger

# IQ-tree module
module load IQ-TREE/1.6.12
# Run partition finder within IQ-tree
iqtree -nt 16 -s analyses/L1648/alignments/concat/kcg2/aa/kcg2_concat.faa \
 -spp analyses/L1648/alignments/concat/kcg2/aa/kcg2_aa_Gpart \
 -m MF+MERGE -mset LG -rclusterf 10 -rcluster-max 100 \
 -pre analyses/L1648/trees/concat/kcg2/aa/kcg2_concat