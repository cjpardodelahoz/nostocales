#!/bin/bash

#SBATCH --mem-per-cpu=6G # adjust as needed
#SBATCH -n 12
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L1648_concat_pmsf_kcg.out
#SBATCH --error=log/L1648_concat_pmsf_kcg.err
#SBATCH --partition=scavenger

# Load IQ-tree module
module load IQ-TREE/1.6.12-MPI
# Run iq-tree mpi
mpirun -np 12 iqtree-mpi -nt 8 \
 -s analyses/L1648/alignments/concat/kcg/aa/kcg_concat.faa -m LG+C60+F+G4 \
 -ft analyses/L1648/trees/concat/kcg/aa/kcg_concat_guide.treefile \
 -pre analyses/L1648/trees/concat/kcg/aa/kcg_concat_pmsf -bb 1000