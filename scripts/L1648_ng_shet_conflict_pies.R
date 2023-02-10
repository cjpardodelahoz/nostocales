#!/usr/bin/env Rscript

# Load required packages and functions
library(tidyverse)
source("scripts/r_functions.R")

# Read and tidy DiscoVista output for the L1648+ng+shet gene vs concat conflict analysis

# Load discov output table
discov_out <- read_csv("analyses/conflict/discovista_out/gene_vs_concat/L1648_aa_ng_shet/single.metatable.results.csv")
# Sumarize discov output per bipartition
discov_df_top <- condense_discov_out_weak(discov_out) %>%
  select(bipart, percent_concordant:percent_weak_support) %>%
  pivot_longer(percent_concordant:percent_weak_support, names_to = "support", values_to = "percent") 

# Named vector of colors for piecharts
pie_colors <- c("percent_concordant" = "#40549f", "percent_discordant" = "#ea4753", 
                "percent_uninformative" = "#9b979c", "percent_weak_reject" = "#e8db7e", 
                "percent_weak_support" = "#4599ad")
# Generate pies
conflict_pies <- ggplot(discov_df_top, aes(x = "", y = percent, fill = support)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = pie_colors) +
  theme_void() +
  facet_wrap("bipart")
ggsave(plot = conflict_pies, filename = "fig2_conflict_pies.df")
