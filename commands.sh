#!/bin/bash

####### GENOME QC AND PRELIMINARY PHYLOGENY (FIG. S1) #######

# Run busco on all 220 genomes with the cyanodb10 (conserved on cyanobacteria)
sbatch busco_all_cyanodb10.sh
# Use busco results to taxa by completeness (90% threshold) and to generate L746
# This script writes two files:
# taxa_passed_qc.txt    the list of 211 taxa that we kept after the filtering
# misc_files/L746.txt   The list of busco loci part of the L746 dataset
# It also contains code fo a couple of histograms (not saved) showing the 
# distribution of taxa and loci.
Rscript scripts/filter_taxa_and_loci_all.R
# Get sequence files for each of the busco loci
# This script will create the busco sequence files in analyses/prelim/seqs
# MOVE by_taxon TO analyses/genome_qc/busco/all_cyanodb10/by_taxon
Rscript scripts/sort_busco_seqs_all_cyanodb10.R
# AA alignments
# This will write the alignments to analyses/prelim/alignments/single
sbatch scripts/mafft_all_cyanodb10_aa.sh
# Concatenate the aa alignments
# This will write the concatenated alignment to analyses/prelim/alignments/concat/concat.faa
sbatch scripts/concatenate_all_cyanodb10.sh
