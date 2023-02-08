#!/usr/bin/env Rscript

################# PACKAGES ####################

# Install/load required packages

# install.packages("stringr")
library(stringr)
# install.packages("vegan")
library(vegan)
# install.packages("bipartite")
library(bipartite)
# install.packages("ape")
library(ape)

################# BUSCO SUMMARY ####################

# Load one of the tables
full_table <- read.delim("analyses/genome_qc/busco/all_nostocalesdb10/by_taxon/Anabaena_cylindrica_PCC_7122/run_nostocales_odb10/full_table.tsv", 
                         header=FALSE, comment.char = "#")
# Subset it to get BUSCO ID's
BUSCO_id <- as.data.frame(full_table[,1], header = F)
BUSCO_id <- unique(BUSCO_id)

# Get a list of all busco summary files in the "summary" directory
# so "-" have been replaced by "." in taxa names
reports <- list.files(path = "analyses/genome_qc/busco/all_nostocalesdb10/summary",
                      pattern="summary_", full.names = T, recursive = F)
# remove "./summary_Nostoc_sp_3335mg" from the list using the index
reports <- reports[-c(162)]

# Loop through the result files to get the second column and append it to a
# consolidated table
BUSCO_result <- data.frame(BUSCO_id)
for (report in reports) {
  report_temp <- read.delim(report, header = F, comment.char = "#", sep = "\t")
  report_temp <- report_temp[,1:2]
  report_temp <- unique(report_temp)
  report_temp <- as.data.frame(report_temp[,2])
  BUSCO_result <- data.frame(BUSCO_result, report_temp)
}

# Add the taxa names as the column headers for the matrix
taxa_names <- as.vector(reports)
taxa_names <- str_replace_all(taxa_names, "analyses/genome_qc/busco/all_nostocalesdb10/summary/summary_","")
taxa_names <- c("BUSCO_id", taxa_names)
colnames(BUSCO_result) <- taxa_names

# Save report
write.csv(BUSCO_result, file = "analyses/genome_qc/busco/all_nostocalesdb10/BUSCO_result_all.csv")

# Replaced the "Complete" values for 1 and the rest for zero
BUSCO_result_num <- as.data.frame(BUSCO_result[,2:220], row.names = as.character(BUSCO_result[,1]))
for (j in 1:ncol(BUSCO_result_num)) {
  BUSCO_result_num[,j] <- (str_replace(BUSCO_result_num[,j], "Complete", "1"))
  BUSCO_result_num[,j] <- (str_replace(BUSCO_result_num[,j], "Fragmented", "0"))
  BUSCO_result_num[,j] <- (str_replace(BUSCO_result_num[,j], "Duplicated", "0"))
  BUSCO_result_num[,j] <- (str_replace(BUSCO_result_num[,j], "Missing", "0"))
}

# Convert values to numeric
for (j in 1:ncol(BUSCO_result_num)) {
  BUSCO_result_num[,j] <- as.numeric(BUSCO_result_num[,j])
}
# Save report with numeric values
write.csv(BUSCO_result_num, file = "analyses/genome_qc/busco/all_nostocalesdb10/BUSCO_num_result_all.csv")

# Histogram of loci per taxon and taxon per loci
hist(rowSums(BUSCO_result_num), main = NULL, xlab = "number of taxa", breaks = 20, xlim = c(140, 230))
hist(colSums(BUSCO_result_num), main = NULL, xlab = "number of loci", breaks = 20)

# Sort matrix in nested architechture
nested_BUSCO_result_num <- nestedrank(BUSCO_result_num, weighted = F, return.matrix = T)$nested.matrix
write.csv(nested_BUSCO_result_num, file = "analyses/genome_qc/busco/all_cyanodb10/nested_BUSCO_result_num.csv")

# Rank species and loci by dataset completeness
taxa_ranked <- as.data.frame(colSums(nested_BUSCO_result_num))
loci_ranked <- as.data.frame(rowSums(nested_BUSCO_result_num))

taxa_ranked
loci_ranked

# Get loci codes present in 198 or more taxa (90% of the taxon sampling)
loci_198 <- rowSums(BUSCO_result_num) > 197
loci_198 <- as.data.frame(loci_198, row.names = NULL)
loci_198 <- subset(loci_198, loci_198 == "TRUE")
loci_198 <- rownames(loci_198)

# Save list of kept loci
write(loci_198, file = "misc_files/L1648.txt")