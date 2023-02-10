#!/bin/bash

#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L1082_astral10_ngmin_na.out
#SBATCH --error=log/L1082_astral10_ngmin_na.err
#SBATCH --partition=scavenger

# Load newick utilities conda env
source $(conda info --base)/etc/profile.d/conda.sh
conda activate newick
# Load java for astral
module load Java/1.8.0_60
astral_path=/hpc/group/bio1/carlos/apps/Astral

# Put all trees into a single file
for locus in $(cat misc_files/L1082.txt) ; do
 cat analyses/ngmin/trees/single/na/${locus}_selected_55_ngmin.treefile >> \
 analyses/ngmin/trees/astral/na/ngmin.trees
done
# Collapse nodes with less than 10% UFB
nw_ed analyses/ngmin/trees/astral/na/ngmin.trees 'i & b<=10' \
 o > analyses/ngmin/trees/astral/na/ngmin_bs10.trees
# Run ASTRAL
java -jar ${astral_path}/astral.5.15.1.jar \
 -T 8 \
 -i analyses/ngmin/trees/astral/na/ngmin_bs10.trees \
 -o analyses/ngmin/trees/astral/na/ngmin_astral.tre 2> \
 analyses/ngmin/trees/astral/na/ngmin_astral.log
 