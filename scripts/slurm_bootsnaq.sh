#!/bin/bash

#SBATCH --array=1-100
#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 5 # number of threads per process
#SBATCH --output=log/bootsnaq_%A_%a.out
#SBATCH --error=log/bootsnaq_%A_%a.err
#SBATCH --partition=scavenger

# Path to Julia
export PATH=$HOME/julia-1.5.2/bin/:$PATH
# Paralelize bootsnaq replicates using the array variable to generate
# differente seeds for each replicate
julia scripts/bootSNaQ.jl ${SLURM_ARRAY_TASK_ID}93476