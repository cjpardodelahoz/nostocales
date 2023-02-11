#!/bin/bash

#SBATCH --array=1-1293
#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/pbsum_%A_%a.out
#SBATCH --error=log/pbsum_%A_%a.err
#SBATCH --partition=scavenger

# Path to mbsum
export PATH=$HOME/apps:$PATH
# Variable with loci codes and paths
locus=$(ls analyses/phylonetworks/alignments/*c1.pb | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Run mbsum
mbsum -n 2001 -o analyses/phylonetworks/bucky/infiles/${locus%_c*}.in \
 ${locus%_c*}_c1 ${locus%_c*}_c2