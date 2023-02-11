#!/bin/bash

#SBATCH --array=1-50
#SBATCH --mem-per-cpu=8G # adjust as needed
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/731_guide_array.%A_%a.out
#SBATCH --error=log/731_guide_array.%A_%a.err
#SBATCH --partition=scavenger

# Load iqtree
module load IQ-TREE/1.6.12
# Run iqtree
iqtree -nt 6 -s analyses/phylogenomic_jackknifing/alignments/concat/731_rep${SLURM_ARRAY_TASK_ID}.phy \
 -m LG+C20+F+G4 \
 -pre analyses/phylogenomic_jackknifing/trees/731_rep${SLURM_ARRAY_TASK_ID}_guide
