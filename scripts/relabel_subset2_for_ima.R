#!/usr/bin/env Rscript

# Load required packages
library(tidyverse)
library(phylotools)

# Load label reference table
ref_table <- readr::read_csv(file = "analyses/ancestral_ne/full_run_2/clade_taxon_assignments.csv") %>%
  tidyr::drop_na() %>%
  dplyr::select(1:2)
# List of sequence files to rename
seq_paths <- list.files(path = "analyses/ancestral_ne/full_run_2/seqs", 
                        pattern = "subset2.fna", full.names = T)
# Loop thorugh the seqs and rename them
for (seq_in in seq_paths) {
  seq_out <- stringr::str_replace(seq_in, pattern = ".fna", 
                                  replacement = "_relabeled.fna")
  phylotools::rename.fasta(infile = seq_in, ref_table = ref_table, outfile = seq_out)
}
