#!/usr/bin/env Rscript

library(stringr)

# Load alignment summaries for taxa subset 1
subset1_aa_ng_summary <- read.delim("analyses/phylonetworks/alignment_summaries/subset1_ng_aln_aa.summary", row.names = NULL)
# Get list of loci to remove
subset1_loci_rm <- subset(subset1_aa_ng_summary, No_of_taxa < 12)$Alignment_name
# Write file with loci to remove (with <12 taxa)
write(subset1_loci_rm, file = "misc_files/subset1_loci_rm.txt")
# Get list of loci kept for subset1
subset1_loci <- subset(subset1_aa_ng_summary, No_of_taxa >= 12)$Alignment_name
subset1_loci <- str_remove(subset1_loci, ".phy")
# Write file with loci used for subset 1
write(subset1_loci, file = "misc_files/subset1_loci.txt")