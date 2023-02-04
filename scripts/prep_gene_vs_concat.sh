#!/bin/bash

# Variable with datasets that were only trimmed to no gaps (+ng)
datasets="L31 L70 L746 ngmin"
# Loop through these datasets and sort the trees
for dataset in ${datasets} ; do
 # Directory in to store inputs for DiscoVista
 mkdir -p analyses/conflict/discovista_in/gene_vs_concat/${dataset}/trees
 # Fetch aa trees
 scripts/prep_discov_trees.sh analyses/${dataset}/trees/single/aa \
  treefile \
  analyses/conflict/discovista_in/gene_vs_concat/${dataset}_aa/trees single
 # Fetch na trees
 scripts/prep_discov_trees.sh analyses/${dataset}/trees/single/na \
  treefile \
  analyses/conflict/discovista_in/gene_vs_concat/${dataset}_na/trees single
done

# Variable with the trimming filters used for the L1648 alignments
filters="ng strict kcg kcg2"
# Loop through these filters and sort the L1648 trees
for filter in ${filters} ; do
 # Directories in to store inputs for DiscoVista
 mkdir -p analyses/conflict/discovista_in/gene_vs_concat/L1648_aa_${filter}_sho/trees
 mkdir -p analyses/conflict/discovista_in/gene_vs_concat/L1648_aa_${filter}_shet/trees
 mkdir -p analyses/conflict/discovista_in/gene_vs_concat/L1648_na_${filter}/trees
 # Fetch aa site-homo trees
 scripts/prep_discov_trees.sh analyses/L1648/trees/single/${filter}/aa \
  sho.treefile \
  analyses/conflict/discovista_in/gene_vs_concat/L1648_aa_${filter}_sho/trees single
 # Fetch aa site-hete trees
 scripts/prep_discov_trees.sh analyses/L1648/trees/single/${filter}/aa \
  ${filter}.treefile \
  analyses/conflict/discovista_in/gene_vs_concat/L1648_aa_${filter}_shet/trees single
 # Fetch na trees
 scripts/prep_discov_trees.sh analyses/L1648/trees/single/${filter}/na \
  treefile \
  analyses/conflict/discovista_in/gene_vs_concat/L1648_na_${filter}/trees single
done