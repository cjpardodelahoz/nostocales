#!/bin/bash

#SBATCH --mem-per-cpu=12G  # adjust as needed
#SBATCH -n 12 # number of processes
#SBATCH -c 4 # number of threads per process
#SBATCH --output=log/L1082_concat_pfml_ngmin_na.out
#SBATCH --error=log/L1082_concat_pfml_ngmin_na.err
#SBATCH --partition=scavenger

# Load IQ-tree mpi
module load IQ-TREE/1.6.12-MPI
# Infer ml tree using the model inferred previously with partition finder
mpirun -np 12 iqtree-mpi -nt 4 \
 -s analyses/ngmin/alignments/concat/na/ngmin_concat.fna \
 -spp analyses/ngmin/trees/concat/na/ngmin_concat.best_scheme.nex \
 -bb 1000 -bnni -pre analyses/ngmin/trees/concat/na/ngmin_concat_pfml