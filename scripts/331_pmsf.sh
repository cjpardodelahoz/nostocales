#!/bin/bash

#SBATCH --array=1-50
#SBATCH --mem-per-cpu=8G # adjust as needed
#SBATCH -n 2
#SBATCH -c 6 # number of threads per process
#SBATCH --output=log/331_pmsf.%A_%a.out
#SBATCH --error=log/331_pmsf.%A_%a.err
#SBATCH --partition=scavenger

# Load iqtree module
module load IQ-TREE/1.6.12-MPI
# Run iqtree
mpirun -np 2 iqtree-mpi -nt 6 -s analyses/phylogenomic_jackknifing/alignments/concat/331_rep${SLURM_ARRAY_TASK_ID}.phy \
 -m LG+C60+F+G4 \
 -ft analyses/phylogenomic_jackknifing/trees/331_rep${SLURM_ARRAY_TASK_ID}_guide.treefile \
 -pre .analyses/phylogenomic_jackknifing/trees/331_rep${SLURM_ARRAY_TASK_ID}_pmsf \
 -bb 1000
