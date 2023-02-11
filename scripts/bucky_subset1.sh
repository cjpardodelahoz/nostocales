#!/bin/bash

#SBATCH --array=1-495
#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/bucky_%A_%a.out
#SBATCH --error=log/bucky_%A_%a.err
#SBATCH --partition=scavenger

# Path to bucky
export PATH=$HOME/apps:$PATH
# Run bucky to infer concordance factors
~/apps/bucky-slurm.pl analyses/phylonetworks/bucky/infiles \
 --out-dir analyses/phylonetworks/bucky/outfiles \
 --alpha 1 --ngen 1000000 \
 -q $SLURM_ARRAY_TASK_ID