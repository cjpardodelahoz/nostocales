#!/bin/bash

#SBATCH --array=1-2586
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/prep_mbsum_trees_%A_%a.out
#SBATCH --error=log/prep_mbsum_trees_%A_%a.err
#SBATCH --partition=scavenger

module load R/4.0.0

trees=$(ls analyses/phylonetworks/alignments/*.treelist | sed -n ${SLURM_ARRAY_TASK_ID}p)

scripts/prep_trees_for_mbsum.sh scripts/newick_to_nexus.R ${trees}