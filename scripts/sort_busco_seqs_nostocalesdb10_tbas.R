#!/usr/bin/env Rscript

# Load required libraries and custom functions
library(tidyverse)
library(phylotools)
source("scripts/r_functions.R")

# Load genome ids of 211 taxa
sample_ids <- scan("misc_files/taxa_passed_qc.txt", what = "character")
# Get busco aa seq files
sort_busco_seqs(sample_ids = sample_ids,
                busco_out_dir = "analyses/genome_qc/busco/all_nostocalesdb10/by_taxon/", 
                busco_db = "run_nostocales_odb10", 
                out_file_name = "full_table.tsv",
                data_type = "AA",
                out_dir = "analyses/tbas/seqs", 
                busco_ids_file = "misc_files/busco_ids_nostocalesdb10_tbas.txt")
# Get busco na seq files
sort_busco_seqs(sample_ids = sample_ids,
                busco_out_dir = "analyses/genome_qc/busco/all_nostocalesdb10/by_taxon/", 
                busco_db = "run_nostocales_odb10", 
                out_file_name = "full_table.tsv",
                data_type = "DNA",
                out_dir = "analyses/tbas/seqs", 
                busco_ids_file = "misc_files/busco_ids_nostocalesdb10_tbas.txt")