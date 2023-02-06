#!/bin/bash

# Prepare directories and trees for DiscoVista analyses comparing species trees
# (concatenated and ASTRAL)

# Prepare concat trees for DiscoVista input
for tree in $(cd analyses/conflict/concat_trees && ls *.treefile) ; do
  mkdir -p analyses/conflict/discovista_in/concat/trees/${tree%.treefile}-concat
  cp analyses/conflict/concat_trees/${tree%.treefile} \
   analyses/conflict/discovista_in/concat/trees/${tree}-concat/estimated_species_tree.tree
done

# Gather all astral trees
# Variable with datasets that were only trimmed to no gaps (+ng)
datasets="L31 L70 L746 ngmin"
# Loop through these datasets and gather the concatenated trees
mkdir -p analyses/conflict/astral_trees
for dataset in ${datasets} ; do
 cp analyses/${dataset}/trees/astral/aa/ng_astral.tre \
  analyses/conflict/astral_trees/${dataset}_aa
 cp analyses/${dataset}/trees/astral/na/ng_astral.tre \
  analyses/conflict/astral_trees/${dataset}_na
done
# Variable with the trimming filters used for the L1648 alignments
filters="ng strict kcg kcg2"
# Loop through these filters and sort the L1648 trees
for filter in ${filters} ; do
 cp analyses/L1648/trees/astral/aa/${filter}_shet_astral.tre \
  analyses/conflict/astral_trees/L1648_aa_${filter}_shet.treefile
 cp analyses/L1648/trees/astral/aa/${filter}_sho_astral.tre \
  analyses/conflict/astral_trees/L1648_aa_${filter}_sho.treefile
 cp analyses/L1648/trees/astral/na/${filter}_astral.tre \
  analyses/conflict/astral_trees/L1648_na_${filter}.treefile
done
# Prepare ASTRAL trees for DiscoVista input
for tree in $(cd analyses/conflict/astral_trees && ls *.treefile) ; do
  mkdir -p analyses/conflict/discovista_in/astral/trees/${tree%.treefile}-astral
  cp analyses/conflict/astral_trees/${tree%.treefile} \
    analyses/conflict/discovista_in/astral/trees/${tree%.treefile}-astral/estimated_species_tree.tree
done