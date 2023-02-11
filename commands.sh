#!/bin/bash

####### GENOME QC AND PRELIMINARY PHYLOGENY (FIG. S1) ########

# Run busco on all 220 genomes with the cyanodb10 (conserved on cyanobacteria)
sbatch busco_all_cyanodb10.sh
# Use busco results to taxa by completeness (90% threshold) and to generate L746
# This script writes two files:
# misc_files/taxa_passed_qc.txt    the list of 211 taxa that we kept after the filtering
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
# This will write trimmmed alignments to analyses/L31/alignments/single
sbatch scripts/trimal_L31_subset0_ng.sh
# Remove trimal crap from headers
sbatch scripts/fix_headers_L31_subset0.sh
# Get codon partition file for nucleotide alignments
# Codon partition files will be written to analyses/L31/alignments/single/${locus}_ng_Cpart
scripts/get_codon_partition_L31_subset0.sh
# Run ML gene trees with iqtree
# All iqtree output will be written to analyses/L31/trees/single/aa|na
# The tree file will be analyses/L31/trees/single/aa|na/${locus}_seelcted_55_ng.treefile
sbatch scripts/ml_gene_trees_L31_subset0_aa.sh
sbatch scripts/ml_gene_trees_L31_subset0_na.sh
# Concatenate sequences
# Concatenated alignments will be in analyses/L31/alignments/concat
sbatch scripts/concatenate_L31_subset0.sh
# Get codon partition file for the na concatenated alignments
# Codon partitions will be in analyses/L31/alignments/concat/na/ng_na_Cpart
scripts/get_codon_partition_concat_ng_L31.sh
# Infer aa concatenated guide tree for PMSF
sbatch scripts/L31_concat_guide_ng.sh
# Infer aa concatenated PMSF tree
# The pmsf tree will be in analyses/L31/trees/concat/aa/ng_concat_pmsf.treefile
sbatch scripts/L31_concat_pmsf_ng.sh
# Run partition finder for na concat alignment within iqtree
# The partition and model file will be in analyses/L31/trees/concat/na/ng_concat.best_scheme.nex
sbatch scripts/L31_concat_pf_ng_na.sh
# Infer ml concat tree for na using partitions from pf
# The tree will be in analyses/L31/trees/concat/na/ng_concat_pfml.treefile
sbatch scripts/L31_concat_pfml_ng_na.sh
# Run ASTRAL on gene trees with branches < %10 UFBoot collapsed
# The astral trees wimm be in analyses/L31/trees/astral/aa|na/ng_astral.tre
sbatch scripts/L31_astral10_ng_na.sh
sbatch scripts/L31_astral10_ng_aa.sh

# L70

# AA alignments
# This will write the alignments to analyses/L70/alignments/single
sbatch scripts/mafft_L70_subset0_aa.sh
# NA alignments with PAL2NAL
# This will align the nucleotides using the amino acid aligment as a guideline
# and will write the alignments to analyses/L70/alignments/single
sbatch scripts/pal2nal_L70_subset0.sh
# Trim gaps from alignments using trimal
# This will write trimmmed alignments to analyses/L70/alignments/single
sbatch scripts/trimal_L70_subset0_ng.sh
# Remove trimal crap from headers
sbatch scripts/fix_headers_L70_subset0.sh
# Get codon partition file for nucleotide alignments
# Codon partition files will be written to analyses/L70/alignments/single/${locus}_ng_Cpart
scripts/get_codon_partition_L70_subset0.sh
# Run ML gene trees with iqtree
# All iqtree output will be written to analyses/L70/trees/single/aa|na
# The tree file will be analyses/L70/trees/single/aa|na/${locus}_seelcted_55_ng.treefile
sbatch scripts/ml_gene_trees_L70_subset0_aa.sh
sbatch scripts/ml_gene_trees_L70_subset0_na.sh
# Concatenate sequences
# Concatenated alignments will be in analyses/L70/alignments/concat
sbatch scripts/concatenate_L70_subset0.sh
# Get codon partition file for the na concatenated alignments
# Codon partitions will be in analyses/L70/alignments/concat/na/ng_na_Cpart
scripts/get_codon_partition_concat_ng_L70.sh
# Infer aa concatenated guide tree for PMSF
sbatch scripts/L70_concat_guide_ng.sh
# Infer aa concatenated PMSF tree
# The pmsf tree will be in analyses/L70/trees/concat/aa/ng_concat_pmsf.treefile
sbatch scripts/L70_concat_pmsf_ng.sh
# Run partition finder for na concat alignment within iqtree
# The partition and model file will be in analyses/L70/trees/concat/na/ng_concat.best_scheme.nex
sbatch scripts/L70_concat_pf_ng_na.sh
# Infer ml concat tree for na using partitions from pf
# The tree will be in analyses/L70/trees/concat/na/ng_concat_pfml.treefile
sbatch scripts/L70_concat_pfml_ng_na.sh
# Run ASTRAL on gene trees with branches < %10 UFBoot collapsed
# The astral trees wimm be in analyses/L70/trees/astral/aa|na/ng_astral.tre
sbatch scripts/L70_astral10_ng_na.sh
sbatch scripts/L70_astral10_ng_aa.sh

# L746

# Get sequence files for each of the busco loci
# This script will create the busco sequence files in analyses/L746/seqs
# It will run faster with higher memory (peak at ~32 GB RAM)
Rscript scripts/sort_busco_seqs_cyanodb10_subset0.R
# Add the "selected_55"" suffix to the seqs 
for locus in $(cat misc_files/L746.txt) ; do
 mv analyses/L746/seqs/${locus}.fna analyses/L746/seqs/${locus}_selected_55.fna
 mv analyses/L746/seqs/${locus}.faa analyses/L746/seqs/${locus}_selected_55.faa
done
# Add the "selected_55" suffix to the seqs and the loci identifiers
sed -i.bak "s|$|_selected_55|" misc_files/L746.txt
rm misc_files/L746.txt.bak
# AA alignments
# This will write the alignments to analyses/L746/alignments/single
sbatch scripts/mafft_L746_subset0_aa.sh
# NA alignments with PAL2NAL
# This will align the nucleotides using the amino acid aligment as a guideline
# and will write the alignments to analyses/L746/alignments/single
sbatch scripts/pal2nal_L746_subset0.sh
# Trim gaps from alignments using trimal
# This will write trimmmed alignments to analyses/L746/alignments/single
sbatch scripts/trimal_L746_subset0_ng.sh
# Remove trimal crap from headers
sbatch scripts/fix_headers_L746_subset0.sh
# Get codon partition file for nucleotide alignments
# Codon partition files will be written to analyses/L746/alignments/single/${locus}_ng_Cpart
scripts/get_codon_partition_L746_subset0.sh
# Run ML gene trees with iqtree
# All iqtree output will be written to analyses/L746/trees/single/aa|na
# The tree file will be analyses/L746/trees/single/aa|na/${locus}_seelcted_55_ng.treefile
sbatch scripts/ml_gene_trees_L746_subset0_aa.sh
sbatch scripts/ml_gene_trees_L746_subset0_na.sh
# Concatenate sequences
# Concatenated alignments will be in analyses/L746/alignments/concat
sbatch scripts/concatenate_L746_subset0.sh
# Get codon partition file for the na concatenated alignments
# Codon partitions will be in analyses/L746/alignments/concat/na/ng_na_Cpart
scripts/get_codon_partition_concat_ng_L746.sh
# Infer aa concatenated guide tree for PMSF
sbatch scripts/L746_concat_guide_ng.sh
# Infer aa concatenated PMSF tree
# The pmsf tree will be in analyses/L746/trees/concat/aa/ng_concat_pmsf.treefile
sbatch scripts/L746_concat_pmsf_ng.sh
# Run partition finder for na concat alignment within iqtree
# The partition and model file will be in analyses/L746/trees/concat/na/ng_concat.best_scheme.nex
sbatch scripts/L746_concat_pf_ng_na.sh
# Infer ml concat tree for na using partitions from pf
# The tree will be in analyses/L746/trees/concat/na/ng_concat_pfml.treefile
sbatch scripts/L746_concat_pfml_ng_na.sh
# Run ASTRAL on gene trees with branches < %10 UFBoot collapsed
# The astral trees wimm be in analyses/L746/trees/astral/aa|na/ng_astral.tre
sbatch scripts/L746_astral10_ng_na.sh
sbatch scripts/L746_astral10_ng_aa.sh

#L1648

# Run busco on all 220 genomes with the nostocalesdb10 (conserved on nostocales)
sbatch busco_all_nostocalesdb10.sh
# Use busco results to taxa by completeness (90% threshold) and to generate L1648
# This script writes two files:
# misc_files/L1648.txt          The list of busco loci part of the L1648 dataset
# It also contains code for a couple of histograms showing the 
# distribution of taxa and loci.
Rscript scripts/filter_loci_nostocalesdb10.R
# Get sequence files for each of the busco loci
# This script will create the busco sequence files in analyses/L1648/seqs
# It will run faster with higher memory (peak at ~32 GB RAM)
Rscript scripts/sort_busco_seqs_nostocalesdb10_subset0.R
# Add the "selected_55"" suffix to the seqs 
for locus in $(cat misc_files/L1648.txt) ; do
 mv analyses/L1648/seqs/${locus}.fna analyses/L1648/seqs/${locus}_selected_55.fna
 mv analyses/L1648/seqs/${locus}.faa analyses/L1648/seqs/${locus}_selected_55.faa
done
# Add the "selected_55" suffix to the seqs and the loci identifiers
sed -i.bak "s|$|_selected_55|" misc_files/L1648.txt
# AA alignments
# This will write the alignments to analyses/L1648/alignments/single
sbatch scripts/mafft_L1648_subset0_aa.sh
# NA alignments with PAL2NAL
# This will align the nucleotides using the amino acid aligment as a guideline
# and will write the alignments to analyses/L1648/alignments/single
sbatch scripts/pal2nal_L1648_subset0.sh
# Trim alignments using trimal and clipkit
# This will write trimmmed alignments to analyses/L1648/alignments/single
sbatch scripts/trimal_L1648_subset0_ng.sh
sbatch scripts/trimal_L1648_subset0_strict.sh
sbatch scripts/clipkit_L1648_subset0_kcg.sh
sbatch scripts/clipkit_L1648_subset0_kcg2.sh
# Remove trimal crap from headers
sbatch scripts/fix_headers_L1648_subset0.sh
# Get codon partition file for nucleotide alignments
# Codon partition files will be written to analyses/L1648/alignments/single/${locus}_ng_Cpart
scripts/get_codon_partition_L1648_subset0_ng.sh
# Run nucleotide ML gene trees with iqtree
# All these searches were done with site-homogeneous models (sho)
# All nucleotide iqtree output will be written to analyses/L1648/trees/single/ng|strict|kcg|kcg2/na/
# The tree file will be analyses/L1648/trees/single/ng/na/${locus}_seelcted_55_ng.treefile
# Will not upload ufboot and checkpoint files to save space
sbatch scripts/ml_gene_trees_L1648_subset0_na_ng.sh
sbatch scripts/ml_gene_trees_L1648_subset0_na_strict.sh
sbatch scripts/ml_gene_trees_L1648_subset0_na_kcg.sh
sbatch scripts/ml_gene_trees_L1648_subset0_na_kcg2.sh
# Run amino acid ML gene trees with iqtree
# All these searches were done considering site-heterogeneous models
# All iqtree output will be written to analyses/L1648/trees/single/ng|strict|kcg|kcg2/aa/
# The tree file will be analyses/L1648/trees/single/ng/aa/${locus}_seelcted_55_ng.treefile
sbatch scripts/ml_gene_trees_L1648_subset0_aa_ng.sh
sbatch scripts/ml_gene_trees_L1648_subset0_aa_strict.sh
sbatch scripts/ml_gene_trees_L1648_subset0_aa_kcg.sh
sbatch scripts/ml_gene_trees_L1648_subset0_aa_kcg2.sh
# All following searches were done with site-homogeneous models (sho)
# All iqtree output will be written to analyses/L1648/trees/single/ng|strict|kcg|kcg2/aa/
# The tree file will be analyses/L1648/trees/single/ng/aa/${locus}_seelcted_55_ng_sho.treefile
sbatch scripts/ml_gene_trees_L1648_subset0_aa_ng_sho.sh
sbatch scripts/ml_gene_trees_L1648_subset0_aa_strict_sho.sh
sbatch scripts/ml_gene_trees_L1648_subset0_aa_kcg_sho.sh
sbatch scripts/ml_gene_trees_L1648_subset0_aa_kcg2_sho.sh
# Concatenate sequences
# Concatenated alignments will be in analyses/L1648/alignments/concat/ng|strict|kcg|kcg2
sbatch scripts/concatenate_L1648_subset0.sh
# Get codon partition file for the na concatenated alignment
# Codon partitions will be in analyses/L1648/alignments/concat/ng/na/ng_na_Cpart
scripts/get_codon_partition_concat_ng_L1648.sh
# Infer aa concatenated guide trees for PMSF
sbatch scripts/L1648_concat_guide_ng.sh
sbatch scripts/L1648_concat_guide_strict.sh
sbatch scripts/L1648_concat_guide_kcg.sh
sbatch scripts/L1648_concat_guide_kcg2.sh
# Infer aa concatenated PMSF trees
# The pmsf tree will be in analyses/L1648/trees/concat/ng/aa/ng_concat_pmsf.treefile
sbatch scripts/L1648_concat_pmsf_ng.sh # This produces the tree presented in Fig. 2
sbatch scripts/L1648_concat_pmsf_strict.sh
sbatch scripts/L1648_concat_pmsf_kcg.sh
sbatch scripts/L1648_concat_pmsf_kcg2.sh
# Run partition finder for aa concat alignment within iqtree with site-homogeneous
# models only
sbatch scripts/L1648_concat_pf_ng_aa.sh
sbatch scripts/L1648_concat_pf_strict_aa.sh
sbatch scripts/L1648_concat_pf_kcg_aa.sh
sbatch scripts/L1648_concat_pf_kcg2_aa.sh
# Run concatenated partitioned trees with site-homogeneous models
sbatch scripts/L1648_concat_pfml_ng_aa.sh
sbatch scripts/L1648_concat_pfml_strict_aa.sh
sbatch scripts/L1648_concat_pfml_kcg_aa.sh
sbatch scripts/L1648_concat_pfml_kcg2_aa.sh
# Run partition finder for na concat alignment within iqtree
# The partition and model file will be in analyses/L1648/trees/concat/ng/na/ng_concat.best_scheme.nex
sbatch scripts/L1648_concat_pf_ng_na.sh
sbatch scripts/L1648_concat_pf_strict_na.sh
sbatch scripts/L1648_concat_pf_kcg_na.sh
sbatch scripts/L1648_concat_pf_kcg2_na.sh
# Infer ml concat tree for na using partitions from pf
# The tree will be in analyses/L1648/trees/concat/ng/na/ng_concat_pfml.treefile
sbatch scripts/L1648_concat_pfml_ng_na.sh
sbatch scripts/L1648_concat_pfml_strict_na.sh
sbatch scripts/L1648_concat_pfml_kcg_na.sh
sbatch scripts/L1648_concat_pfml_kcg2_na.sh
# Run ASTRAL on gene trees with branches < %10 UFBoot collapsed
# The astral trees will be in analyses/L1648/trees/astral/aa|na/${filter}_astral.tre
# I made a loop inside the script to run all trimming strategies in a single job.
# This works here because Astral si very fast, so this saves some lines of code
sbatch scripts/L1648_astral10_all_trimming_na.sh
sbatch scripts/L1648_astral10_all_trimming_aa.sh
# Get alignment summaries with AMAS. We will use this later for comparisons
# of the alignment features and to generate the L1082 and L1233 datasets
sbatch summarize_L1648_subset0_alns.sh

# L1082 and L1233

# I called the L1082 and L1233 the "ngmin" datasets, for minimal with no gaps.
# The idea was to remove alignments with low phylogenetic signal. 
# I took the resulting gene trees from the L1648 datasets and fitted a curve to 
# the relationship between the mean UFBoot support and the number of variable 
# sites from each alignment. Finally, we inferred the y-value of the inflexion 
# point of this curve and retained the loci for the alignments that yielded 
# trees with mean UFBoot equal to or higer than that inflexion point.
# This script will produce the list of the loci that were kept with that
# criterium. Amino acids (misc_files/L1233.txt) and nucleotides 
# (misc_files/L1082.txt). It will also produce tha plots in Fig. S2, which show,
# the relationship between no. of varable sites and mean ufboot for na and aa.
Rscript scripts/ngmin.R
# Run treeshrink on the aa L1233 and na L1082 loci to remove taxa on unusually
# long branches from the ng alignments prior to the new set of phylogenetic
# alignments.
scripts/prep_treeshrink_input.sh
# Run tree shrink on the L1233 and L1082 datasets
sbatch scripts/treeshink_aa.sh
sbatch scripts/treeshink_na.sh
# Sort shrunk alignments into the ngmin alignments directory
scripts/sort_shrunk_alns.sh
# Generate codon partition for ngmin nucleotide alignments (L1082)
scripts/get_codon_partition_L1082_subset0_ngmin.sh
# Run ML gene trees with iqtree
# All iqtree output will be written to analyses/ngmin/trees/single/aa|na
# The tree file will be analyses/ngmin/trees/single/aa|na/${locus}_seelcted_55_ng.treefile
sbatch scripts/ml_gene_trees_L1233_subset0_aa.sh
sbatch scripts/ml_gene_trees_L1082_subset0_na.sh
# Concatenate sequences
# Concatenated alignments will be in analyses/L746/alignments/concat
sbatch scripts/concatenate_ngmin_subset0.sh
# Get codon partition file for the na concatenated alignments
# Codon partitions will be in analyses/ngmin/alignments/concat/na/ngmin_na_Cpart
scripts/get_codon_partition_concat_ngmin_L1082.sh
# Infer aa concatenated guide tree for PMSF
sbatch scripts/L1233_concat_guide_ngmin.sh
# Infer aa concatenated PMSF tree
# The pmsf tree will be in analyses/ngmin/trees/concat/aa/ngmin_concat_pmsf.treefile
sbatch scripts/L1233_concat_pmsf_ngmin.sh
# Run partition finder for na concat alignment within iqtree
# The partition and model file will be in analyses/ngmin/trees/concat/na/ngmin_concat.best_scheme.nex
sbatch scripts/L1082_concat_pf_ngmin_na.sh
# Infer ml concat tree for na using partitions from pf
# The tree will be in analyses/ngmin/trees/concat/na/ngmin_concat_pfml.treefile
sbatch scripts/L1082_concat_pfml_ngmin_na.sh
# Run ASTRAL on gene trees with branches < %10 UFBoot collapsed
# The astral trees wimm be in analyses/L746/trees/astral/aa|na/ng_astral.tre
sbatch scripts/L1082_astral10_ngmin_na.sh
sbatch scripts/L1233_astral10_ngmin_aa.sh

####### COMPARISON OF L1648 ALIGMENTS (FIG S3) ########

# Generate the plots from Fig. S3 that summarize the features
# of the L1648 alignments
Rscript scripts/L1648_alignment_features.R

####### SUBSTITUTION MODEL FIT FOR L1648 AA DATASET (FIG S4) ########

# Compile ModelFinder output from the L1648 amino acid datasets. This will
# extract the ModelFinder output table from the IQ-Tree log for each locus and
# write it into a file in modelfinder_out/
scripts/compile_mf_outputs.sh
# Compare the BIC of the best site-heterogeneous and the best site-homogeneous
# models for each locus in the L1648+ng amino acid datasets and generate
# Figure S4
Rscript scripts/bic_diff_plot.R

####### ANALYSES OF PHYLOGENETIC CONFLICT (FIGS 2, 3, S6 and S7) ########

# Gene trees vs concatenated trees

# Prepare directories and trees for DiscoVista analyses comparing gene trees
# to the corresponding concatenated tree inferred with the same loci set
scripts/prep_gene_vs_concat.sh
# Generate the clade definitions file required by discovista. This file needs to
# have all the bipartitions included in the reference tree that will be 
# compared to the corresponding gene trees. Therefore, we need one clade_def file
# per dataset. This requires the GO package bp. Look inside the script for
# installation instructions
scripts/gene_vs_concat_clade_defs.sh
# Run DiscoVista to compare gene trees to the corresponding concatenated tree
# This analyses was run locally on our iMac Pro.
for dataset in $(cd analyses/conflict/discovista_in/gene_vs_concat && ls) ; do
  docker run -v $(pwd):/data esayyari/discovista discoVista.py -m 0 -k 1 \
  -c analyses/conflict/discovista_in/gene_vs_concat/${dataset}/clade_def \
  -p analyses/conflict/discovista_in/gene_vs_concat/${dataset}/trees \
  -t 95 -o analyses/conflict/discovista_out/gene_vs_concat/${dataset}/
done
# Summarize the gene tree conflict analyses and compare the proportion of
# conflicting gene trees per bipartition across the different datasets (Figs S6-S7)
Rscript scripts/gene_vs_concat_conflict_summary.R
# Get the pie charts summarizing the gene tree conflict on each bipartition of
# the tree inferred with the amino acid L1648+ng+site-hete (Fig. 2). The numbers
# of the pie charts correspond to the bipartition numbers as defined in the 
# analyses/conflict/gene_vs_concat/L1648_aa_ng_shet/clade_def files
Rscript scripts/L1648_ng_shet_conflict_pies.R

# Species trees vs 22 focal bipartitions

# Prepare directories and trees for DiscoVista analyses comparing species trees
# (concatenated and ASTRAL) to 22 focal bipartitions
scripts/prep_species_vs_22_biparts.sh
# Run DiscoVista to compare concat trees to the 22 focal bipartitions
# I prepared the clade_def file for the following two analyses by hand
# so it included the 22 focal bipartitions. The results of this analyses were
# used to generate Fig. 3.
# Both of these analyses were run locally on our iMac Pro.
docker run -v $(pwd):/data esayyari/discovista discoVista.py -m 0 -k 1 \
 -c analyses/conflict/discovista_in/concat/clade_def \
 -p analyses/conflict/discovista_in/concat/trees \ 
 -t 95 -o analyses/conflict/discovista_out/concat
# Run DiscoVista to compare astral trees to the 22 focal bipartitions
docker run -v $(pwd):/data esayyari/discovista discoVista.py -m 0 -k 1 \
 -c analyses/conflict/discovista_in/astral/clade_def \
 -p analyses/conflict/discovista_in/astral/trees \ 
 -t 95 -o analyses/conflict/discovista_out/concat
 
####### INFERENCE OF PHYLOGENETIC NETWORK WITH SNaQ (FIG 4a) ########

# Bayesian gene trees

# Prepare alignments for phylonetwork analyses. Take the aa L1648+ng alignments
# and remove the taxa that are not part of subset 1 
# (misc_files/taxa_dropped_subset1.txt)
scripts/prep_phylonetwork_alns.sh
# Get list of loci with missing taxa and remove the alignments
Rscript scripts/get_loci_to_rm_subset1.R
for locus in $(cat misc_files/subset1_loci_rm.txt) ; do
 rm analyses/phylonetworks/alignments/${locus}
done
# Run ModelFinder within iqtree to find best fit models among the ones available
# in phylobayes
sbatch scripts/subset1_aa_ng_mf.sh
# Extract the ModelFinder result tables 
scripts/get_mf_out.sh misc_files/L1648.txt.bak \
 analyses/phylonetworks/modelfinder_bulk \
 subset1_ng.log \
 analyses/phylonetworks/modelfinder_out \
 subset1_ng
# Generate the PhyloBayes commands for each locus using the best fit model found
# with ModelFinder
Rscript scripts/write_pb_commands_subset1.R
# Run two chain samplers with Phylobayes to get gene tree posteriors
sbatch scripts/pb_subset1_c1.sh
sbatch scripts/pb_subset1_c2.sh

# Infer concordance factors with BUCKy

# Add star tree at the top of all files with the posterior so all trees will have
# taxa in the same order when converted to nexus. This is required by BUCy
scripts/pb_trees_taxon_order.sh
# Prepare trees to run mbsum by converting them to mrbayes nexus format
sbatch scripts/prep_pbsum_subset1.sh
# Run mbsum to prepare posterior trees for bucky
sbatch scripts/pbsum_subset1.sh
# Infer concordance factors with BUCKy
sbatch scripts/bucky_subset1.sh

# Network search with snaq

# Consolidate the bucky results into a single table with all concordance factors
mkdir -p analyses/phylonetworks/snaq
cat analyses/phylonetworks/bucky/outfiles/*.cf > \
 analyses/phylonetworks/snaq/CFtable_noheader.csv
# Add the header tot he CF table
cat misc_files/CFheader analyses/phylonetworks/snaq/CFtable_noheader.csv > \
 analyses/phylonetworks/snaq/CFtable.csv
# Run snaq to serach for phylonetworks with h=0 to h=4 using the astral topology
# for subset 1 as a starting tree (analyses/phylonetworks/snaq/start_tree_subset1.tre)
# Based on the pseudolikelihood scores (analyses/phylonetworks/snaq/plog_scores.csv)
# The network with h=2 was the best one (Fig 4a)
sbatch scripts/slurm_snaq_subset1.sh
# Run a bootstrap analysis with 100 replicates on the snaq best network
# This analyses will use the best network, net0 and the same CF table
mkdir -p analyses/phylonetworks/snaq/bootstrap
sbatch scripts/slurm_bootsnaq.sh


####### DIVERGENCE TIME ESTIMATION WITH MCMCTREE (FIG 4b-c and Fig S5) ########

# We ran these analyses on our iMacPro. Note that this is the only time that
# we executed softwar in subdirectoreis of the project. Make sure to go back to root
# once you are done with MCMCTREE

# Prepare directories
mkdir -p analyses/divtime/data
mkdir -p analyses/divtime/gH
mkdir -p analyses/divtime/mcmc/c{1..3]
mkdir -p analyses/divtime/prior/c{1..3}
# We took the major edge tree topology from the snaq network with h=2 and used it
# as a constraint for this analysis. The newick file is under 
# analyses/divtime/data/subset1.tree. We added one calibration to that tree.
# Concatenate subset1 alignments
AMAS.py concat -i analyses/phylonetworks/alignments/*.phy \
 -f phylip -d aa -u phylip -c 4 \
 -t analyses/divtime/data/subset1_ng_concat.phy
# go to gH directory and execute the outBV control file
cd ../gH/
mcmctree mcmctree-outBV.ctl
# Remove the out.BV file and the rst files
rm out.BV
rm rst*
# Modify the the tmp0001.ct file:
# model = 2 * 2: Empirical
# aaRatefile = lg.dat
# MAKE SURE THE lg.dat FILE IS IN THE DIRECTORY
# generate the out.BV file with the LG+G4 model
codeml tmp0001.ctl
# copy file with g and Hessian to the mcmc chain directory
cp rst2 ../mcmc/c1/in.BV
cp rst2 ../mcmc/c2/in.BV
cp rst2 ../mcmc/c3/in.BV
cd ../mcmc/c1
# run mcmc to sample posterior
mcmctree mcmctree_c1.ctl
cd ../c2
mcmctree mcmctree_c2.ctl
cd ../c3
mcmctree mcmctree_c3.ctl
# run mcmc with no data to sample the prior
cd ../../prior/c1
mcmctree mcmctree_pr_c1.ctl
cd ../c2
mcmctree mcmctree_pr_c2.ctl
cd ../c3
mcmctree mcmctree_pr_c3.ctl
# Go back to the project root directory!
cd ../../../../
# Summarize the results of the prior and posterior and chain convergence
Rscript mcmctree_results.R


####### PHYLOGENOMIC JACKKNIFFING (FIG 5 and Fig S8) ########

# Generate jackknife samples of loci
Rscript scripts/sample_jackknife_sets.R
# Concatenate the alignments for each jackknife sample
scripts/prep_jackknife_alns.sh
# Run ml guide trees for all sets
sbatch scripts/31-131_guide.sh
sbatch scripts/331_guide.sh
sbatch scripts/531_guide.sh
sbatch scripts/731_guide.sh
sbatch scripts/1131_guide.sh
# Run ml pmsf trees for all sets
sbatch scripts/31-131_pmsf.sh
sbatch scripts/331_pmsf.sh
sbatch scripts/531_pmsf.sh
sbatch scripts/731_pmsf.sh
sbatch scripts/1131_pmsf.sh
# Summarize results of the jackknife. This will produce the plots in Fig 5
# and the tree topologies shown in Fig S8
Rscript scripts/jackknife_summary.R
