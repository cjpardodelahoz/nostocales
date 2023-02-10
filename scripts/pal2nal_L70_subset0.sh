#!/bin/bash

#SBATCH --array=1-70
#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/L70_pal2nal.%A_%a.out
#SBATCH --error=log/L70_pal2nal.%A_%a.err
#SBATCH --partition=common

# PAL2NAL on path
export PATH=/hpc/group/bio1/carlos/apps/pal2nal.v14:${PATH}
# Variable with loci file names
locus=$(cat misc_files/L70.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Align nucleotides according to amino acid alignments
pal2nal.pl analyses/L70/alignments/single/${locus}_aln.faa \
 analyses/L70/seqs/${locus}.fna -output fasta -codontable 11 > \
 analyses/L70/alignments/single/${locus}_aln.fna