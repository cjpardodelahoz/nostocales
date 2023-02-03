#!/bin/bash

# This is a script to sort the shrunk alignmetns from treeshrink for the ngmin
# datasets into the alignments directory
# ngmin alignments directory
mkdir -p analyses/ngmin/alignments/single
# Loop through the L1082 na alignments and copy them to the alignments directory
for locus in $(< misc_files/L1082.txt) ; do
  cp analyses/ngmin/treeshrink/data/na/${locus}/output.fas \
  analyses/ngmin/alignments/single/${locus}_selected_55_ngmin.fna
done
# Loop through the L1233 aa alignments and copy them to the alignments directory
for locus in $(< misc_files/L1233.txt) ; do
  cp analyses/ngmin/treeshrink/data/aa/${locus}/output.fas \
  analyses/ngmin/alignments/single/${locus}_selected_55_ngmin.faa
done