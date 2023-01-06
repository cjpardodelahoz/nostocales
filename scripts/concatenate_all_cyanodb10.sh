#!/bin/bash

#SBATCH --mem-per-cpu=8G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/concatenate_all_cyanodb10.out
#SBATCH --error=log/concatenate_all_cyanodb10.err
#SBATCH --partition=scavenger

# Path to AMAS
export PATH=/hpc/group/bio1/carlos/apps/AMAS/amas:${PATH}
# Output directory
mkdir -p analyses/prelim/alignments/concat
# Variable with paths to single aa alignments
aln_dir=analyses/prelim/alignments/single/
aln_paths=$(cat misc_files/busco_ids_cyanodb10.txt | sed "s|^|${aln_dir}|")
# Concatenate aa alignments with AMAS
AMAS.py concat -i ${aln_paths} \
-f fasta -d aa -p analyses/prelim/alignments/concat/gene_partition_ng_na \
--part-format raxml --concat-out analyses/prelim/alignments/concat/concat.faa
