#!/bin/bash

#SBATCH --mem-per-cpu=12G  # adjust as needed
#SBATCH -n 12 # number of processes
#SBATCH -c 4 # number of threads per process
#SBATCH --output=log/L1648_concat_pfml_strict_na.out
#SBATCH --error=log/L1648_concat_pfml_strict_na.err
#SBATCH --partition=scavenger

# Load IQ-tree mpi
module load IQ-TREE/1.6.12-MPI
# Infer ml tree using the model inferred previously with partition finder
mpirun -np 12 iqtree-mpi -nt 4 \
 -s analyses/L1648/alignments/concat/strict/na/strict_concat.fna \
 -spp analyses/L1648/trees/concat/strict/na/strict_concat.best_scheme.nex \
 -bb 1000 -bnni -pre analyses/L1648/trees/concat/strict/na/strict_concat_pfml