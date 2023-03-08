#!/bin/bash

#SBATCH --mem-per-cpu=4G
#SBATCH -c 1
#SBATCH --error=log/compile_16s_tbas.err
#SBATCH --output=log/compile_16s_tbas.out
#SBATCH --partition=scavenger

# MAFFT-Dash homologs on path
export PATH=$HOME/mafft-7.475-with-extensions/bin/:$PATH
# Load NCBI module (required)
module load NCBI-BLAST/2.7.1
# Variable with genome names
genomes=$(cat misc_files/taxa_passed_qc.txt)
# Compile 16s seqs
touch analyses/tbas/seqs/16s.fna
for genome in ${genomes} ; do
 if [[ analyses/genomes_annotation/${genome}/16s.fas  ]] ; then
  cat analyses/genomes_annotation/${genome}/16s.fas >> \
      analyses/tbas/seqs/16s.fna
 fi
done
# Align 16S seqs with mafft
mafft --globalpair --maxiterate 100 --thread 1 \
 analyses/tbas/seqs/16s.fna > \
 analyses/tbas/alignments/single/16s_aln.fna