#!/bin/bash

#SBATCH --array=1-1648
#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/L1648_pal2nal_tbas.%A_%a.out
#SBATCH --error=log/L1648_pal2nal_tbas.%A_%a.err
#SBATCH --partition=common

# PAL2NAL on path
export PATH=/hpc/group/bio1/carlos/apps/pal2nal.v14:${PATH}
# Variable with loci file names
locus=$(cat misc_files/L1648.txt.bak | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Align nucleotides according to amino acid alignments
pal2nal.pl analyses/tbas/alignments/single/${locus}_aln.faa \
 analyses/tbas/seqs/${locus}.fna -output fasta -codontable 11 > \
 analyses/tbas/alignments/single/${locus}_aln.fna