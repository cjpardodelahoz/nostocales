#!/bin/bash

#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L1648_astral10_all_trimming_na.out
#SBATCH --error=log/L1648_astral10_all_trimming_na.err
#SBATCH --partition=scavenger

# Load newick utilities conda env
source $(conda info --base)/etc/profile.d/conda.sh
conda activate newick
# Load java for astral
module load Java/1.8.0_60
astral_path=/hpc/group/bio1/carlos/apps/Astral
# Define variable with trimming strategies
filters="kcg kcg2 ng strict"
# Loop through the filters
for filter in ${filters} ; do
 # Put all trees into a single file for each filter
 for locus in $(cat misc_files/L1648.txt) ; do
  cat analyses/L1648/trees/single/${filter}/na/${locus}_${filter}.treefile >> \
  analyses/L1648/trees/astral/na/${filter}.trees
 done
 # Collapse nodes with less than 10% UFB
 nw_ed analyses/L1648/trees/astral/na/${filter}.trees 'i & b<=10' \
  o > analyses/L1648/trees/astral/na/${filter}_bs10.trees
 # Run ASTRAL
 java -jar ${astral_path}/astral.5.15.1.jar \
  -T 8 \
  -i analyses/L1648/trees/astral/na/${filter}_bs10.trees \
  -o analyses/L1648/trees/astral/na/${filter}_astral.tre 2> \
  analyses/L1648/trees/astral/na/${filter}_astral.log
done