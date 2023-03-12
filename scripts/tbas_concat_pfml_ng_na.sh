#!/bin/bash

#SBATCH --mem-per-cpu=8G  # adjust as needed
#SBATCH -n 12 # number of processes
#SBATCH -c 6 # number of threads per process
#SBATCH --output=log/tbas_concat_pfml_ng_na.out
#SBATCH --error=log/tbas_concat_pfml_ng_na.err
#SBATCH --partition=scavenger

# Load IQ-tree mpi
module load IQ-TREE/1.6.12-MPI
# Infer ml tree using the model inferred previously with partition finder
mpirun -np 12 iqtree-mpi -nt 6 \
 -s analyses/tbas/alignments/concat/concat_ng.fna \
 -spp analyses/tbas/trees/concat/concat_pf_ng_na.best_scheme.nex \
 -bb 1000 -bnni -pre analyses/tbas/trees/concat/ng_concat_pfml