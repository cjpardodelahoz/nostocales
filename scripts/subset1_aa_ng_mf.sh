#!/bin/bash

#SBATCH --array=1-1293
#SBATCH --mem-per-cpu=2G  # adjust as needed
#SBATCH -c 1 # number of threads per process
#SBATCH --output=log/subset1_aa_ng_mf.%A_%a.out
#SBATCH --error=log/subset1_aa_ng_mf.%A_%a.err
#SBATCH --partition=scavenger

# Load Iq-tree module
module load IQ-TREE/1.6.12
# Variable with loci prefix
locus=$(cat misc_files/subset1_loci.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)
# Run ModelFinder with the models avaialable in Phylobayes
iqtree -nt 1 -pre analyses/phylonetworks/modelfinder_bulk/${locus} \
 -s analyses/phylonetworks/alignments/${locus}.phy \
 -mset LG,WAG,JTT,MTREV,MTZOA,MTART \
 -madd LG+C10,LG+C20,LG+C30,LG+C40,LG+C50,LG+C60 \
 -m MF -mrate +G -mfreq FU