#!/bin/bash

#SBATCH --mem-per-cpu=8G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/concatenate_tbas_na.out
#SBATCH --error=log/concatenate_tbas_na.err
#SBATCH --partition=scavenger

export PATH=/hpc/group/bio1/carlos/apps/AMAS/amas:${PATH}

mkdir -p analyses/tbas/alignments/concat
# Make variable with paths to filtered alignments
aln_dir=analyses/tbas/alignments/single/
aln_paths=$(cat misc_files/tbas_loci.txt | sed 's/$/_ng.fna/' | sed "s|^|${aln_dir}|")

AMAS.py concat -i ${aln_paths} \
 -f fasta -d dna -p analyses/tbas/alignments/concat/gene_partition_ng_na \
 --part-format raxml \
 --concat-out analyses/tbas/alignments/concat/concat_ng.fna