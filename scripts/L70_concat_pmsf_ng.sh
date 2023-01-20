#!/bin/bash

#SBATCH --mem-per-cpu=8G # adjust as needed
#SBATCH -n 12
#SBATCH -c 4 # number of threads per process
#SBATCH --output=log/L70_concat_pmsf.out
#SBATCH --error=log/L70_concat_pmsf.err
#SBATCH --partition=scavenger

# Load IQ-tree module
module load IQ-TREE/1.6.12-MPI
# Run iq-tree mpi
mpirun -np 12 iqtree-mpi -nt 4 \
 -s analyses/L70/alignments/concat/aa/ng_concat.faa -m LG+C60+F+G4 \
 -ft analyses/L70/trees/concat/aa/ng_concat_guide.treefile \
 -pre analyses/L70/trees/concat/aa/ng_concat_pmsf -bb 1000