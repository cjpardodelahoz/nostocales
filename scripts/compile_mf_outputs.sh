#!/bin/bash

# This is a script to compile the model finder outputs from iqtree runs on the 
# amino acid L1648 datasets with different trimming and site-heterogeneity methods

# Make directory for model finder output files
mkdir analyses/L1648/modelfinder_out
# Define variable with alignment filters for which we will obtain the mf output
filters="kcg kcg2 ng strict"
# loop through the different filter directories to get the mf output using the
# get_mf_out.sh script
for filter in ${filters} ; do 
  scripts/get_mf_out.sh misc_files/L1648.txt \
   analyses/L1648/trees/single/${filter}/aa \
   selected_55_${filter}.log \
   analyses/L1648/modelfinder_out \
   selected_55_aa_${filter}
done