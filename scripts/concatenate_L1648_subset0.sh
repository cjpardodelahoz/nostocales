#!/bin/bash

#SBATCH --mem-per-cpu=8G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/concatenate_L1648.out
#SBATCH --error=log/concatenate_L1648.err
#SBATCH --partition=scavenger

# Path to AMAS
export PATH=/hpc/group/bio1/carlos/apps/AMAS/amas:${PATH}
# Define variable with trimming strategies
filters="kcg kcg2 ng strict"
# Loop through the filters and concatenate
for filter in ${filters} ; do
  mkdir -p analyses/L1648/alignments/concat/${filter}/na
  mkdir -p analyses/L1648/alignments/concat/${filter}/aa
  # Concatenate nucleic acids
 AMAS.py concat -i analyses/L1648/alignments/single/*${filter}.fna -f fasta -d dna \
  -p analyses/L1648/alignments/concat/${filter}/na/${filter}_na_Gpart \
  --concat-out analyses/L1648/alignments/concat/${filter}/na/${filter}_concat.fna \
  --part-format raxml
# Concatenate amino acids
 AMAS.py concat -i analyses/L1648/alignments/single/*${filter}.faa -f fasta -d aa \
  -p analyses/L1648/alignments/concat/${filter}/aa/${filter}_aa_Gpart \
  --concat-out analyses/L1648/alignments/concat/${filter}/aa/${filter}_concat.faa \
  --part-format raxml
done