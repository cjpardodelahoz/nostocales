#!/usr/bin/env Rscript

# Script to sample jackknife subsets of loci

# Load required libraries and functions
library(tidyverse)
source("scripts/r_functions.R")

# Load list of L1648 loci codes
L1648 <- scan(file = "misc_files/subset1_loci.txt", what = "character")
# Get sequence of number of loci to evaluate bootstrap in concatenation
no_of_loci_seq <- c(31, 51, 71, 91, 111, 131, 331, 531, 731, 1131)
# Sample sets of loci names and write to files
sample_loci_seq(no_of_loci_seq, reps = 50, loci_names = L1648, 
                path = "analyses/phylogenomic_jackknifing/loci_samples/",
                prefix = "analyses/phylogenomic_jackknifing/alignments/single",
                suffix = "_subset1_ng.phy")
