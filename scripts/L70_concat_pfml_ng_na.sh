#!/bin/bash

#SBATCH --mem-per-cpu=12G  # adjust as needed
#SBATCH -n 6 # number of processes
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L70_concat_pfml_ng_na.out
#SBATCH --error=log/L70_concat_pfml_ng_na.err
#SBATCH --partition=scavenger

# Load IQ-tree mpi
module load IQ-TREE/1.6.12-MPI
# Infer ml tree using the model inferred previously with partition finder
mpirun -np 6 iqtree-mpi -nt 8 \
 -s analyses/L70/alignments/concat/na/ng_concat.fna \
 -spp analyses/L70/trees/concat/na/ng_concat.best_scheme.nex \
 -bb 1000 -bnni -pre analyses/L70/trees/concat/na/ng_concat_pfml