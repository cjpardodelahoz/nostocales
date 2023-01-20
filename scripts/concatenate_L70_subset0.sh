#!/bin/bash

#SBATCH --mem-per-cpu=8G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/concatenate_L70.out
#SBATCH --error=log/concatenate_L70.err
#SBATCH --partition=scavenger

# Path to AMAS
export PATH=/hpc/group/bio1/carlos/apps/AMAS/amas:${PATH}
# Concatenate nucleic acids
AMAS.py concat -i analyses/L70/alignments/single/*ng.fna -f fasta -d dna \
 -p analyses/L70/alignments/concat/na/ng_na_Gpart \
 --concat-out analyses/L70/alignments/concat/na/ng_concat.fna \
 --part-format raxml
# Concatenate amino acids
AMAS.py concat -i analyses/L70/alignments/single/*ng.faa -f fasta -d aa \
 -p analyses/L70/alignments/concat/aa/ng_aa_Gpart \
 --concat-out analyses/L70/alignments/concat/aa/ng_concat.faa \
 --part-format raxml