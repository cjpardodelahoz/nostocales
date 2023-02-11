#!/bin/bash

#SBATCH --array=1-300
#SBATCH --mem-per-cpu=8G # adjust as needed
#SBATCH -c 4 # number of threads per process
#SBATCH --output=log/31-131_guide.%A_%a.out
#SBATCH --error=log/31-131_guide.%A_%a.err
#SBATCH --partition=scavenger

# Load iqtree module
module load IQ-TREE/1.6.12
# Variable with alignment files
aln=$(cd analyses/phylogenomic_jackknifing/alignments/concat && ls *.phy | sort -g | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Run iqtree
iqtree -nt 4 -s analyses/phylogenomic_jackknifing/alignments/concat/${aln} -m LG+C20+F+G4 \
-pre analyses/phylogenomic_jackknifing/trees/${aln%.phy}_guide
