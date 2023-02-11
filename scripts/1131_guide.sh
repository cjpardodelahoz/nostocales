#!/bin/bash

#SBATCH --array=1-50
#SBATCH --mem-per-cpu=4G # adjust as needed
#SBATCH -c 12 # number of threads per process
#SBATCH --output=log/1131_guide_array.%A_%a.out
#SBATCH --error=log/1131_guide_array.%A_%a.err
#SBATCH --partition=scavenger

# Load iqtree module
module load IQ-TREE/1.6.12
# run iqtree
iqtree -nt 12 -s analyses/phylogenomic_jackknifing/alignments/concat/1131_rep${SLURM_ARRAY_TASK_ID}.phy \
 -m LG+C20+F+G4 \
 -pre analyses/phylogenomic_jackknifing/trees/1131_rep${SLURM_ARRAY_TASK_ID}_guide
