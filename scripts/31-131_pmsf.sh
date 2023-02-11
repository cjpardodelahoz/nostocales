#!/bin/bash

#SBATCH --array=1-300
#SBATCH --mem-per-cpu=8G # adjust as needed
#SBATCH -n 2
#SBATCH -c 4 # number of threads per process
#SBATCH --output=log/131_rep1_pmsf.%A_%a.out
#SBATCH --error=log/131_rep1_pmsf.%A_%a.err
#SBATCH --partition=scavenger

# Load iqtree module
module load IQ-TREE/1.6.12-MPI
# Load iqtree module
aln=$(cd analyses/phylogenomic_jackknifing/alignments/concat && ls *.phy | sort -g | sed -n ${SLURM_ARRAY_TASK_ID}p)

mpirun -np 2 iqtree-mpi -nt 4 \
 -s analyses/phylogenomic_jackknifing/alignments/concat/${aln} \
 -m LG+C60+F+G4 \
 -ft analyses/phylogenomic_jackknifing/trees/${aln%.phy}_guide.treefile \
 -pre analyses/phylogenomic_jackknifing/trees/${aln%.phy}_pmsf -bb 1000
