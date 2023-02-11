#!/usr/bin/env Rscript

# Libraries and custom functions
source("scripts/r_functions.R")
library(tidyverse)

# Load file with site heterogenous modes evaluated (madd)
madd <- read.csv("misc_files/madd", check.names = F) %>% colnames()
# Write files with phylobayes commands
write_pb_command(mf_path = "analyses/phylonetworks/modelfinder_out", 
                 aln_filter = "ng", suffix = "_subset1_", 
                 madd = madd, 
                 out_path = "analyses/phylonetworks/alignments/")