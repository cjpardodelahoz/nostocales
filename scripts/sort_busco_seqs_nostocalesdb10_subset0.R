#!/usr/bin/env Rscript

# Load required libraries and custom functions
library(tidyverse)
library(phylotools)
source("scripts/r_functions.R")

# Load genome ids part of subset 0 
# 55 taxa selected to represent the diversity of Nostocales. 
# See Bold taxa in Fig. S1.
sample_ids <- scan("misc_files/taxa_selected_55.txt", what = "character")
# Get busco na seq files
sort_busco_seqs(sample_ids = sample_ids,
                busco_out_dir = "analyses/genome_qc/busco/all_nostoacalesdb10/by_taxon", 
                busco_db = "run_nostocales_odb10", 
                out_file_name = "full_table.tsv",
                data_type = "DNA",
                out_dir = "analyses/L1648/seqs", 
                busco_ids_file = "misc_files/L1648.txt")
# Get busco aa seq files
sort_busco_seqs(sample_ids = sample_ids,
                busco_out_dir = "analyses/genome_qc/busco/all_nostoacalesdb10/by_taxon", 
                busco_db = "run_nostocales_odb10", 
                out_file_name = "full_table.tsv",
                data_type = "AA",
                out_dir = "analyses/L1648/seqs", 
                busco_ids_file = "misc_files/L1648.txt")
