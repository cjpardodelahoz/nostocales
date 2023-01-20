#!/bin/bash

#SBATCH --mem-per-cpu=6G # adjust as needed
#SBATCH -n 4
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L31_concat_pmsf.out
#SBATCH --error=log/L31_concat_pmsf.err
#SBATCH --partition=scavenger

# Load IQ-tree module
module load IQ-TREE/1.6.12-MPI
# Run iq-tree mpi
mpirun -np 4 iqtree-mpi -nt 8 \
 -s analyses/L31/alignments/concat/aa/ng_concat.faa -m LG+C60+F+G4 \
 -ft analyses/L31/trees/concat/aa/ng_concat_guide.treefile \
 -pre analyses/L31/trees/concat/aa/ng_concat_pmsf -bb 1000