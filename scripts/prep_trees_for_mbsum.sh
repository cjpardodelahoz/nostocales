#!/bin/bash

# This is a script to convert tree files from newick format from phylobayes to
# nexus format required by mbsum. Run in the command line as:
# prep_mbsum_trees.sh path/to/newick_to_nexus.R path/to/treelist

# Convert tree files to nexus
Rscript ${1} ${2}
# Replace the "TREE * UNTITLED" with "tree gen.0" and the "&R" with "&U"
sed 's/\&R/\&U/' ${2}.nex | \
sed 's/TREE \* UNTITLED/tree gen\.0/g' > ${2%.treelist}