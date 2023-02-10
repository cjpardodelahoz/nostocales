#!/usr/bin/env Rscript

# Load alignment summaries for taxa subset 1
subset1_aa_ng_summary <- read.delim("analyses/phylonetworks/alignment_summaries/subset1_ng_aln_aa.summary", row.names = NULL)
# Get list of loci to remove
subset1_loci_rm <- subset(subset1_aa_ng_summary, No_of_taxa < 12)$Alignment_name
# Write file with loci to remove (with <12 taxa)
write(subset1_loci_rm, file = "misc_files/subset1_loci_rm.txt")