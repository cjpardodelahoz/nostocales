#!/bin/bash

#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 10 # number of threads per process
#SBATCH --output=log/snaq.out
#SBATCH --error=log/snaq.err
#SBATCH --partition=scavenger

export PATH=/hpc/home/cjp47/julia-1.5.2/bin/:$PATH

julia scripts/snaq_subset1.jl