#!/bin/bash

####### GENOME QC AND PRELIMINARY PHYLOGENY (FIG. S1) ########

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
# It will run faster with higher memory (peak at ~32 GB RAM)
Rscript scripts/sort_busco_seqs_all_cyanodb10.R
# AA alignments
# This will write the alignments to analyses/prelim/alignments/single
sbatch scripts/mafft_all_cyanodb10_aa.sh
# Concatenate the aa alignments
# This will write the concatenated alignment to analyses/prelim/alignments/concat/concat_aa.phy
sbatch scripts/concatenate_all_cyanodb10.sh
# Infer preliminary ml concatenated tree with RAxML
# This will write the tree to analyses/prelim/trees/concat/concat_aa.tree
sbatch scripts/prelim_concat_tree.sh

####### ALIGNMENTS, GENE AND SPECIES TREES FOR SUBSET 1 (55 TAXA) ########

# L31

# AA alignments
# This will write the alignments to analyses/L31/alignments/single
sbatch scripts/mafft_L31_subset0_aa.sh
# NA alignments with PAL2NAL
# This will align the nucleotides using the amino acid aligment as a guideline
# and will write the alignments to analyses/L31/alignments/single
sbatch scripts/pal2nal_L31_subset0.sh
# Trim gaps from alignments using trimal
sbatch scripts/trimal_L31_subset0_ng.sh
# Remove trimal crap from headers
sbatch scripts/fix_headers_L31_subset0.sh
# Get codon partition file for nucleotide alignments
scripts/get_codon_partition_L31_subset0.sh
# Run ML gene trees with iqtree
sbatch scripts/ml_gene_trees_L31_subset0_aa.sh
sbatch scripts/ml_gene_trees_L31_subset0_na.sh


