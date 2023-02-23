#!/bin/bash

#SBATCH --array=1-211
#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/prokka_211_%A_%a.out
#SBATCH --error=log/prokka_211_%A_%a.err
#SBATCH --partition=scavenger

source $(conda info --base)/etc/profile.d/conda.sh
conda activate prokka

genome=$(cat misc_files/taxa_passed_qc.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)

prokka --cpus 8 --metagenome --prefix ${genome} \
--outdir analyses/genomes_annotation/${genome} --centre dukegcb \
--compliant --force genomes/${genome}