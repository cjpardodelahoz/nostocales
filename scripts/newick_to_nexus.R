#!/bin/R

# This is a script to convert trees from newick to nexus format

# Read the treefile name from command line
file_name = commandArgs(trailingOnly = TRUE)

# Required libraries
library(ape)

# loop through the tree files, load them, save them in nexus format
trees <- read.tree(file = file_name)
write.nexus(trees, file = paste(file_name, ".nex", sep = ""))