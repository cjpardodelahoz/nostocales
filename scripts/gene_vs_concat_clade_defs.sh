#!/bin/bash

# Generate the clade definitions file required by discovista. This file needs to
# have all the bipartitions included in the reference tree that will be 
# compared to the corresponding gene trees. Therefore, we need one clade_def file
# per dataset.

# Requires bp. Install as follows:
# Download and install go
# https://go.dev/doc/install
# Create a go module (which will create the go.mod file)
# cd ~/gophy
# go mod init gophy
# Clone the github repo
# git clone https://github.com/FePhyFoFum/gophy.git
# Install the missing compiler library
# brew install nlopt
# Install bp and add it to path
# go build gophy/bp/bp.go

# Gather all concatenated trees
# Variable with datasets that were only trimmed to no gaps (+ng)
datasets="L31 L70 L746 ngmin"
# Loop through these datasets and gather the concatenated trees
mkdir -p analyses/conflict/concat_trees
for dataset in ${datasets} ; do
 cp analyses/${dataset}/trees/concat/na/ng_concat_pfml.treefile \
  analyses/conflict/concat_trees/${dataset}_na.treefile
 cp analyses/${dataset}/trees/concat/aa/ng_concat_pmsf.treefile \
  analyses/conflict/concat_trees/${dataset}_aa.treefile
done
# Variable with the trimming filters used for the L1648 alignments
filters="ng strict kcg kcg2"
# Loop through these filters and sort the L1648 trees
for filter in ${filters} ; do
 cp analyses/L1648/trees/concat/${filter}/aa/ng_concat_pmsf.treefile \
  analyses/conflict/concat_trees/L1648_aa_${filter}_shet.treefile
 cp analyses/L1648/trees/concat/${filter}/aa/ng_concat_pfml.treefile \
  analyses/conflict/concat_trees/L1648_aa_${filter}_sho.treefile
 cp analyses/L1648/trees/concat/${filter}/na/ng_concat_pfml.treefile \
  analyses/conflict/concat_trees/L1648_na_${filter}.treefile
done
# Get clade def files 
for tree in $(cd analyses/conflict/concat_trees/ && ls *) ; do
  scripts/get_clade_def.sh analyses/conflict/concat_trees/${tree} \
  analyses/conflict/discovista_in/gene_vs_concat/${tree%.treefile}
done