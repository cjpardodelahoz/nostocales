#!/usr/bin/env Rscript

# Load required packages and custom functions
library(tidyverse)
library(RootsExtremaInflections)
library(ggpubr)
source("scripts/r_functions.R")

# Load ng alignment summaries
dash_55_na_ng_summary <- read.delim("analyses/L1648/alignment_summaries/selected_55_na_ng.summary", 
                                    row.names = NULL)
dash_55_aa_ng_summary <- read.delim("analyses/L1648/alignment_summaries/selected_55_aa_ng.summary", 
                                    row.names = NULL)
# Load vector with L1648 loci names
L1648_loci <- scan(file = "misc_files/L1648.txt", what = "character") %>%
  str_remove("_selected_55") %>%
  sort()
# Join sorted loci names with alignment summary dfs
# Here the column will be called "loci_names_198" because these were the loci
# that were present in more than 198 taxa. Not pretty, but it's what I did
# initially so I kept it.
dash_55_na_ng_summary <- dash_55_na_ng_summary %>%        # na df
  add_column(loci_names_198 = 
               sort(L1648_loci))
dash_55_aa_ng_summary <- dash_55_aa_ng_summary %>%        # aa df
  add_column(loci_names_198 = 
               sort(L1648_loci))
# Define paths and suffix for bootstrap function
path_ng_na_trees <- "analyses/L1648/trees/single/ng/na/iqtree/bulk/"
path_ng_aa_trees <- "analyses/L1648/trees/single/ng/aa/iqtree/bulk/"
suffix_ng_trees <- "_selected_55_ng.treefile"
# Get mean bootstraop for ecah tree
# The function get_mean_bootstrap() is defined in r_functions.R
dash_55_na_ng_summary <- dash_55_na_ng_summary %>%        # na df
  mutate(mean_ufboot =
           get_mean_bootstrap(loci_names_198, path = path_ng_na_trees, 
                              suffix = suffix_ng_trees))
dash_55_aa_ng_summary <- dash_55_aa_ng_summary %>%        # aa df
  mutate(mean_ufboot =
           get_mean_bootstrap(loci_names_198, path = path_ng_aa_trees, 
                              suffix = suffix_ng_trees))
# Find inflexion point on bootstrap axis for nucleotides
# The inflection point is indicated by the dashed red line
inflexi(as.numeric(dash_55_na_ng.summary$mean_ufboot), 
        as.numeric(dash_55_na_ng.summary$No_variable_sites),
        i1 = 40, i2 = 100, nt = 2)
# Find inflexion point on bootstrap axis for amino acids
# The inflection point is indicated by the dashed red line
inflexi(as.numeric(dash_55_aa_ng_summary$mean_ufboot), 
        as.numeric(dash_55_aa_ng_summary$No_variable_sites),
        i1 = 40, i2 = 90, nt = 2)
# get loci names above the ufboot inflexion point and with > 100 variable sites
# Nucleotides
loci_boot73 <- dash_55_na_ng_summary %>%
  filter(mean_ufboot >= 72.9 & No_variable_sites >= 100) %>%
  pull(loci_names_198)
# Amino acids
loci_boot60 <- dash_55_aa_ng_summary %>%
  filter(mean_ufboot >= 59.4 & No_variable_sites >= 100) %>%
  pull(loci_names_198)
# Save list of kept loci
write(loci_boot73, file = "misc_files/L1082.txt")
write(loci_boot60, file = "misc_files/L1233.txt")

# Let's make Fig. S2

# Scatter plot function
plot_figS2 <- function(df, yintercept) {
  df %>%
    ggplot(aes(x = No_variable_sites, y = mean_ufboot)) +
    geom_point() +
    geom_hline(yintercept = yintercept, linetype = "dashed", col = "red") +
    geom_vline(xintercept = 100, linetype = "dashed", col = "red") +
    scale_y_continuous(n.breaks = 10) +
    scale_x_continuous(n.breaks = 10) +
    labs(x = "No. of variable sites", y = "Mean UFboot") +
    theme(axis.text = element_text(size=12, color = "black"),
            axis.title = element_text(size = 12, color = "black"),
            axis.line.x = element_blank(),
            axis.line.y = element_blank(),
            panel.border = element_rect(fill = NA, color = "black", size = 1),
            panel.background = element_blank(),
            legend.position = "none",
            aspect.ratio = 3/4)
}
# Plot ufboot vs variable sites for nucleotides
figS2a <- dash_55_na_ng_summary %>%
  plot_figS2(yintercept = 72.9)
# Plot ufboot vs variable sites for amino acids
figS2b <- dash_55_aa_ng_summary %>%
  plot_figS2(yintercept = 59.4)
# Arrange panels
figS2 <- ggarrange(figS2a, figS2b, nrow = 1, ncol = 2)
# save figure
ggsave(filename = "figS2.pdf", plot = figS2, device = "pdf")
