#!/bin/bash

#SBATCH --mem-per-cpu=8G  # adjust as needed
#SBATCH -c 4 # number of threads per process
#SBATCH --output=log/shrink_aa.out
#SBATCH --error=log/shrink_aa.err
#SBATCH --partition=common

# Path to treeshrink
export PATH=${HOME}/TreeShrink:${PATH}
# Load required Library
module load R/3.6.0
# Run Treeshrink with the per-species mode and removing taxa from the alignment 
# if they increase the tree diameter by more than 20% 
run_treeshrink.py -i analyses/ngmin/treeshrink/data/aa \
 -t input.tree -a input.fas \
 -m per-species -b 20 --force