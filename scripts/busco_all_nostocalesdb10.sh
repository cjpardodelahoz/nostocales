#!/bin/bash

#SBATCH --array=1-220
#SBATCH --mem-per-cpu=10G  # adjust as needed
#SBATCH -c 16 # number of threads per process
#SBATCH --output=log/busco_all_nostocalesdb10_%A_%a.out
#SBATCH --error=log/busco_all_nostocalesdb10_%A_%a.err
#SBATCH --partition=scavenger

source $(conda info --base)/etc/profile.d/conda.sh
conda activate busco

S=$(cat misc_files/genome_ids_all.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)

busco -i genomes/${S} -l nostocales_odb10 -m genome \
--out analyses/genome_qc/busco/all_nostocalesdb10/by_taxon/${S} \
--offline --download_path databases/busco_downloads
