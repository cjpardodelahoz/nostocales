#!/usr/bin/env Rscript

# Load required packages and functions
library(tidyverse)
library(ggpubr)
source("scripts/r_functions.R")

# Read and tidy DiscoVista output

# Get paths to discov output tables
discov_out_filenames <- list.files(path = "analyses/conflict/discovista_out/gene_vs_concat", 
                                   pattern = "metatable.results.csv", 
                                   recursive = TRUE, full.names = TRUE)
# Get labels for discov tables
discov_out_labels <- list.files(path = "analyses/conflict/discovista_out/gene_vs_concat", 
                                pattern = "metatable.results.csv", recursive = TRUE) %>%
  str_remove("/.*")
# Load discov output tables
discov_out_tables <- map(discov_out_filenames, read_csv)
names(discov_out_tables) <- discov_out_labels
# Sumarize discov output per bipartition
discov_df <- map(discov_out_tables, condense_discov_out) %>%
  bind_rows(.id = "dataset") %>%
  mutate(data_type =
           str_extract(dataset, "(n|a)a")) %>%
  mutate(trim_method =
           str_extract(dataset, "(kcg2|kcg|ng|strict)")) %>%
  mutate(trim_method =
           replace_na(trim_method, "ng")) %>%
  mutate(site_model = 
           str_extract(dataset, "(shet|sho)")) %>%
  group_by(dataset)

# Plot distribution of bipartition conflict in aa trees (Fig S6)

# Function to create a single boxplot for figS6
fig3_boxplot <- function(df, y_values, fill_color, y_label) {
  df %>%
    ggplot(aes(x = dataset, y = {{ y_values }})) + 
    geom_boxplot(aes(fct_inorder(dataset)), fill = fill_color, outlier.size = 1, outlier.shape = 1) +
    labs(x= "Dataset", y= y_label) +
    scale_y_continuous(n.breaks = 5) +
    theme(axis.text = element_text(size=12, color = "black"),
          axis.title.x = element_blank(),
          axis.title = element_text(size = 12, color = "black"),
          axis.line.x = element_blank(),
          axis.line.y = element_blank(),
          panel.border = element_rect(fill = NA, color = "black", size = 1),
          panel.background = element_blank(),
          legend.position = "none")
}
# % concordant across number of loci
figS6a <- discov_df %>%
  filter(data_type == "aa" & trim_method == "ng" & dataset != "L1648_aa_ng_sho") %>%
  fig3_boxplot(y_values = percent_concordant, fill_color = "#40549f", y_label = "% concordant per bipartition")
# % discordant across number of loci
figS6b <- discov_df %>%
  filter(data_type == "aa" & trim_method == "ng" & dataset != "L1648_aa_ng_sho") %>%
  fig3_boxplot(y_values = percent_discordant, fill_color = "#ea4753", y_label = "% discordant per bipartition")
# % uninformative across number of loci
figS6c <- discov_df %>%
  filter(data_type == "aa" & trim_method == "ng" & dataset != "L1648_aa_ng_sho") %>%
  fig3_boxplot(y_values = percent_uninformative, fill_color = "#9b979c", y_label = "% uninformative per bipartition")
# % concordant across different trim methods site-hete
figS6d <- discov_df %>%
  filter(no_loci == 1648 & site_model == "shet") %>%
  fig3_boxplot(y_values = percent_concordant, fill_color = "#40549f", y_label = "% concordant per bipartition")
# % discordant across different trim methods site-hete
figS6e <- discov_df %>%
  filter(no_loci == 1648 & site_model == "shet") %>%
  fig3_boxplot(y_values = percent_discordant, fill_color = "#ea4753", y_label = "% discordant per bipartition")
# % uninformative across different trim methods site-hete
figS6f <- discov_df %>%
  filter(no_loci == 1648 & site_model == "shet") %>%
  fig3_boxplot(y_values = percent_uninformative, fill_color = "#9b979c", y_label = "% uninformative per bipartition")
# % concordant across different trim methods site-homo
figS6g <- discov_df %>%
  filter(no_loci == 1648 & site_model == c("sho")) %>%
  fig3_boxplot(y_values = percent_concordant, fill_color = "#40549f", y_label = "% concordant per bipartition")
# % discordant across different trim methods site-homo
figS6h <- discov_df %>%
  filter(no_loci == 1648 & site_model == c("sho")) %>%
  fig3_boxplot(y_values = percent_discordant, fill_color = "#ea4753", y_label = "% discordant per bipartition")
# % uniformative across different trim methods site-homo
figS6i <- discov_df %>%
  filter(no_loci == 1648 & site_model == c("sho")) %>%
  fig3_boxplot(y_values = percent_uninformative, fill_color = "#9b979c", y_label = "% uninformative per bipartition")
# Assemble FigS6
figS6 <- ggarrange(figS6a, figS6b, figS6c, figS6d, figS6e, figS6f, figS6g, figS6h, figS6i,
                  nrow = 3, ncol = 3)
ggsave(plot = figS6, filename = "FigS6_plots.pdf")

# Plot distribution of bipartition conflict in na trees (Fig S7)

# % concordant across number of loci
figS7a <- discov_df %>%
  filter(data_type == "na" & trim_method == "ng" & dataset != "L1648_aa_ng_sho") %>%
  fig3_boxplot(y_values = percent_concordant, fill_color = "#40549f", y_label = "% concordant per bipartition")
# % discordant across number of loci
figS7b <- discov_df %>%
  filter(data_type == "na" & trim_method == "ng" & dataset != "L1648_aa_ng_sho") %>%
  fig3_boxplot(y_values = percent_discordant, fill_color = "#ea4753", y_label = "% discordant per bipartition")
# % uninformative across number of loci
figS7c <- discov_df %>%
  filter(data_type == "na" & trim_method == "ng" & dataset != "L1648_aa_ng_sho") %>%
  fig3_boxplot(y_values = percent_uninformative, fill_color = "#9b979c", y_label = "% uninformative per bipartition")
# % concordant across different trim methods site-hete
figS7d <- discov_df %>%
  filter(data_type == "na" & no_loci == 1648) %>%
  fig3_boxplot(y_values = percent_concordant, fill_color = "#40549f", y_label = "% concordant per bipartition")
# % discordant across different trim methods site-hete
figS7e <- discov_df %>%
  filter(data_type == "na" & no_loci == 1648) %>%
  fig3_boxplot(y_values = percent_discordant, fill_color = "#ea4753", y_label = "% discordant per bipartition")
# % uninformative across different trim methods site-hete
figS7f <- discov_df %>%
  filter(data_type == "na" & no_loci == 1648) %>%
  fig3_boxplot(y_values = percent_uninformative, fill_color = "#9b979c", y_label = "% uninformative per bipartition")
# Assemble FigS3
figS7 <- ggarrange(figS7a, figS7b, figS7c, figS7d, figS7e, figS7f,
                   nrow = 2, ncol = 3)
ggsave(plot = figS7, filename = "FigS7_plots.pdf")
