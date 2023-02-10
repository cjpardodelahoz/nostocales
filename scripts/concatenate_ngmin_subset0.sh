#!/bin/bash

#SBATCH --mem-per-cpu=8G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/concatenate_ngmin.out
#SBATCH --error=log/concatenate_ngmin.err
#SBATCH --partition=scavenger

# Path to AMAS
export PATH=/hpc/group/bio1/carlos/apps/AMAS/amas:${PATH}
# Concatenate nucleic acids
AMAS.py concat -i analyses/ngmin/alignments/single/*ngmin.fna -f fasta -d dna \
 -p analyses/ngmin/alignments/concat/na/ngmin_na_Gpart \
 --concat-out analyses/ngmin/alignments/concat/na/ngmin_concat.fna \
 --part-format raxml
# Concatenate amino acids
AMAS.py concat -i analyses/ngmin/alignments/single/*ngmin.faa -f fasta -d aa \
 -p analyses/ngmin/alignments/concat/aa/ngmin_aa_Gpart \
 --concat-out analyses/ngmin/alignments/concat/aa/ngmin_concat.faa \
 --part-format raxml