#!/bin/bash

#SBATCH --mem-per-cpu=12G  # adjust as needed
#SBATCH -n 12 # number of processes
#SBATCH -c 4 # number of threads per process
#SBATCH --output=log/L746_concat_pfml_ng_na.out
#SBATCH --error=log/L746_concat_pfml_ng_na.err
#SBATCH --partition=scavenger

# Load IQ-tree mpi
module load IQ-TREE/1.6.12-MPI
# Infer ml tree using the model inferred previously with partition finder
mpirun -np 12 iqtree-mpi -nt 4 \
 -s analyses/L746/alignments/concat/na/ng_concat.fna \
 -spp analyses/L746/trees/concat/na/ng_concat.best_scheme.nex \
 -bb 1000 -bnni -pre analyses/L746/trees/concat/na/ng_concat_pfml