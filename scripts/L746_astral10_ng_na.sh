#!/bin/bash

#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L746_astral10_ng_na.out
#SBATCH --error=log/L746_astral10_ng_na.err
#SBATCH --partition=scavenger

# Load newick utilities conda env
source $(conda info --base)/etc/profile.d/conda.sh
conda activate newick
# Load java for astral
module load Java/1.8.0_60
astral_path=/hpc/group/bio1/carlos/apps/Astral

# Put all trees into a single file
for locus in $(cat misc_files/L746.txt) ; do
 cat analyses/L746/trees/single/na/${locus}_ng.treefile >> \
 analyses/L746/trees/astral/na/ng.trees
done
# Collapse nodes with less than 10% UFB. Has to run after running astral_set103.sh
nw_ed analyses/L746/trees/astral/na/ng.trees 'i & b<=10' \
 o > analyses/L746/trees/astral/na/ng_bs10.trees
# Run ASTRAL
java -jar ${astral_path}/astral.5.15.1.jar \
 -T 8 \
 -i analyses/L746/trees/astral/na/ng_bs10.trees \
 -o analyses/L746/trees/astral/na/ng_astral.tre 2> \
 analyses/L746/trees/astral/na/ng_astral.log
 