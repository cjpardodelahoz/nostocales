#!/bin/bash

#SBATCH --mem-per-cpu=8G  # adjust as needed
#SBATCH -c 14 # number of threads per process
#SBATCH --output=log/summarize_L1648_subset0_alns.out
#SBATCH --error=log/summarize_L1648_subset0_alns.err
#SBATCH --partition=scavenger

# Path to AMAS
export PATH=/hpc/group/bio1/carlos/apps/AMAS/amas:${PATH}
# Directory for alignment summaries
mkdir -p analyses/L1648/alignment_summaries
# Summarize nucleotides prior to trimming
AMAS.py summary -i analyses/L1648/alignments/single/*_selected_55_aln.fna \
 -f fasta -d dna \
 -o analyses/L1648/alignment_summaries/selected_55_aln_na.summary -c 14
# Summarize amino acids prior to trimming
AMAS.py summary -i analyses/L1648/alignments/single/*_selected_55_aln.faa \
 -f fasta -d aa \
 -o analyses/L1648/alignment_summaries/selected_55_aln_aa.summary -c 14
# Define variable with trimming strategies
filters="kcg kcg2 ng strict"
# Loop through the filters and summarize the alignments
for filter in ${filters} ; do
 # Summarize nucleotide single-loci alignments post-trim
 AMAS.py summary -i analyses/L1648/alignments/single/*${filter}.fna \
  -f fasta -d dna \
  -o analyses/L1648/alignment_summaries/selected_55_na_${filter}.summary -c 14
 # Summarize amino acid single-loci alignments post trim
 AMAS.py summary -i analyses/L1648/alignments/single/*${filter}.faa \
  -f fasta -d aa \
  -o analyses/L1648/alignment_summaries/selected_55_aa_${filter}.summary -c 14
done