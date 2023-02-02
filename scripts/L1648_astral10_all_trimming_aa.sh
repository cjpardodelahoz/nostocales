#!/bin/bash

#SBATCH --mem-per-cpu=4G  # adjust as needed
#SBATCH -c 8 # number of threads per process
#SBATCH --output=log/L1648_astral10_all_trimming_aa.out
#SBATCH --error=log/L1648_astral10_all_trimming_aa.err
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
 # Put all trees into a single file for each filter -site-hete
 for locus in $(cat misc_files/L1648.txt) ; do
  cat analyses/L1648/trees/single/${filter}/aa/${locus}_${filter}.treefile >> \
  analyses/L1648/trees/astral/aa/${filter}_shet.trees
  # Put all trees into a single file for each filter -site-homo
  cat analyses/L1648/trees/single/${filter}/aa/${locus}_${filter}_sho.treefile >> \
  analyses/L1648/trees/astral/aa/${filter}_sho.trees
 done
 # Collapse nodes with less than 10% UFB - site-hete
 nw_ed analyses/L1648/trees/astral/aa/${filter}_shet.trees 'i & b<=10' \
  o > analyses/L1648/trees/astral/aa/${filter}_shet_bs10.trees
  # Collapse nodes with less than 10% UFB - site-homo
 nw_ed analyses/L1648/trees/astral/aa/${filter}_sho.trees 'i & b<=10' \
  o > analyses/L1648/trees/astral/aa/${filter}_sho_bs10.trees
 # Run ASTRAL - site-het
 java -jar ${astral_path}/astral.5.15.1.jar \
  -T 8 \
  -i analyses/L1648/trees/astral/aa/${filter}_shet_bs10.trees \
  -o analyses/L1648/trees/astral/aa/${filter}_shet_astral.tre 2> \
  analyses/L1648/trees/astral/aa/${filter}_shet_astral.log
 # Run ASTRAL - site-homo
 java -jar ${astral_path}/astral.5.15.1.jar \
  -T 8 \
  -i analyses/L1648/trees/astral/aa/${filter}_sho_bs10.trees \
  -o analyses/L1648/trees/astral/aa/${filter}_sho_astral.tre 2> \
  analyses/L1648/trees/astral/aa/${filter}_sho_astral.log
done