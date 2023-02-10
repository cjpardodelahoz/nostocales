#!/bin/bash

#SBATCH --mem-per-cpu=6G # adjust as needed
#SBATCH -n 12
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L1233_concat_pmsf.out
#SBATCH --error=log/L1233_concat_pmsf.err
#SBATCH --partition=scavenger

# Load IQ-tree module
module load IQ-TREE/1.6.12-MPI
# Run iq-tree mpi
mpirun -np 12 iqtree-mpi -nt 8 \
 -s analyses/ngmin/alignments/concat/aa/ngmin_concat.faa -m LG+C60+F+G4 \
 -ft analyses/ngmin/trees/concat/aa/ngmin_concat_guide.treefile \
 -pre analyses/ngmin/trees/concat/aa/ngmin_concat_pmsf -bb 1000