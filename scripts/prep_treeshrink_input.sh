#!/bin/bash

# This is a script to prepare the input files for treeshrink using the L1648+ng 
# datasets

# make directories for treeshrink
mkdir -p analyses/ngmin/treeshrink/data/na
mkdir -p analyses/ngmin/treeshrink/data/aa
# loop through na L1082 loci
for locus in $(cat misc_files/L1082.txt) ; do
  # make locus-specific directory
	mkdir analyses/ngmin/treeshrink/data/na/${locus}
  # copy the corresponding locus tree and alignments
	cp analyses/L1648/trees/single/ng/na/${locus}_selected_55_ng.treefile \
	analyses/ngmin/treeshrink/data/na/${locus}/input.tree
	cp analyses/L1648/alignments/single/${locus}_selected_55_ng.fna \
	analyses/ngmin/treeshrink/data/na/${locus}/input.fas
done
# loop through aa L1233 loci
for locus in $(cat misc_files/L1233.txt) ; do
  # make locus-specific directory
	mkdir analyses/ngmin/treeshrink/data/aa/${locus}
  # copy the corresponding locus tree and alignments
	cp analyses/L1648/trees/single/ng/aa/${locus}_selected_55_ng.treefile \
	analyses/ngmin/treeshrink/data/aa/${locus}/input.tree
	cp analyses/L1648/alignments/single/${locus}_selected_55_ng.faa \
	analyses/ngmin/treeshrink/data/aa/${locus}/input.fas
done