#!/bin/bash

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

# Get clade def files 
for tree in $(cd concat_trees/ && ls *) ; do
  scripts/get_clade_def.sh concat_trees/${tree} discovista_in/gene_vs_concat/${tree%_concat*}
done