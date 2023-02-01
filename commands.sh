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
Rscript scripts/filter_loci_nostocalesdb10_subset0.R # NEEDS TO BE TESTED WHEN I COPY THE SUMMARY FILE
# Get sequence files for each of the busco loci
# This script will create the busco sequence files in analyses/L1648/seqs
# It will run faster with higher memory (peak at ~32 GB RAM)
Rscript scripts/sort_busco_seqs_all_cyanodb10.R # NEEDS TO BE TESTED WHEN I COPY THE BUSCO OUTPUT
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
# Trim gaps from alignments using trimal
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


sbatch scripts/ml_gene_trees_L1648_subset0_aa.sh
sbatch scripts/ml_gene_trees_L1648_subset0_na.sh
# Concatenate sequences
# Concatenated alignments will be in analyses/L1648/alignments/concat
sbatch scripts/concatenate_L1648_subset0.sh
# Get codon partition file for the na concatenated alignments
# Codon partitions will be in analyses/L1648/alignments/concat/na/ng_na_Cpart
scripts/get_codon_partition_concat_ng_L1648.sh
# Infer aa concatenated guide tree for PMSF
sbatch scripts/L746_concat_guide_ng.sh
# Infer aa concatenated PMSF tree
# The pmsf tree will be in analyses/L1648/trees/concat/aa/ng_concat_pmsf.treefile
sbatch scripts/L746_concat_pmsf_ng.sh
# Run partition finder for na concat alignment within iqtree
# The partition and model file will be in analyses/L1648/trees/concat/na/ng_concat.best_scheme.nex
sbatch scripts/L746_concat_pf_ng_na.sh
# Infer ml concat tree for na using partitions from pf
# The tree will be in analyses/L1648/trees/concat/na/ng_concat_pfml.treefile
sbatch scripts/L746_concat_pfml_ng_na.sh
# Run ASTRAL on gene trees with branches < %10 UFBoot collapsed
# The astral trees wimm be in analyses/L1648/trees/astral/aa|na/ng_astral.tre
sbatch scripts/L746_astral10_ng_na.sh
sbatch scripts/L746_astral10_ng_aa.sh
