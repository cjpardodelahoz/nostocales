#!/usr/bin/env Rscript

# This is a script to generate the plots from Fig. S3 that summarize the features
# of the L1648 alignments

# Libraries
library(tidyverse)
# Load alignment summaries
selected_55_aa_aln_unfiltered_sum <- read.delim("analyses/L1648/alignment_summaries/alignment_summaries/selected_55_aln_aa.summary", 
                                                row.names = NULL)
selected_55_na_aln_unfiltered_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_aln_na.summary", 
                                                row.names = NULL)
selected_55_aa_aln_kcg_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_aa_kcg.summary", 
                                         row.names = NULL)
selected_55_na_aln_kcg_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_na_kcg.summary", 
                                         row.names = NULL)
selected_55_aa_aln_kcg2_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_aa_kcg2.summary", 
                                          row.names = NULL)
selected_55_na_aln_kcg2_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_na_kcg2.summary", 
                                          row.names = NULL)
selected_55_aa_aln_strict_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_aa_strict.summary", 
                                            row.names = NULL)
selected_55_na_aln_strict_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_na_strict.summary", 
                                            row.names = NULL)
selected_55_aa_aln_ng_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_aa_ng.summary", 
                                        row.names = NULL)
selected_55_na_aln_ng_sum <- read.delim("analyses/L1648/alignment_summaries/selected_55_na_ng.summary", 
                                        row.names = NULL)
# Group summaries into two dataframes, one for aa and one for na
selected_55_aa_sums <- bind_rows(selected_55_aa_aln_unfiltered_sum, selected_55_aa_aln_kcg_sum, selected_55_aa_aln_kcg2_sum,
                                 selected_55_aa_aln_strict_sum, selected_55_aa_aln_ng_sum)
selected_55_na_sums <- bind_rows(selected_55_na_aln_unfiltered_sum, selected_55_na_aln_kcg_sum, selected_55_na_aln_kcg2_sum,
                                 selected_55_na_aln_strict_sum, selected_55_na_aln_ng_sum)
# Add column indicating trimming method
trim_method <- c(rep("nofilter", 1648), rep("kcg", 1648), rep("kcg2", 1648), rep("strict", 1648), rep("ng", 1648))
selected_55_aa_sums <- add_column(selected_55_aa_sums, trim_method)
selected_55_na_sums <- add_column(selected_55_na_sums, trim_method)

## LET"S MAKE FIGS3 ##

# Amino acids
# Proportion missing plot - aa
aa_proportion_missing_plot <- ggplot(selected_55_aa_sums, aes(trim_method, Missing_percent/100)) + 
  geom_boxplot(aes(fct_inorder(trim_method)), fill = "gray95", outlier.size = 1, outlier.shape = 1) +
  labs(x=NULL, y="Prop. missing") +
  scale_y_continuous(n.breaks = 10) +
  theme(axis.text = element_text(size=10, color = "black"),
        axis.title = element_text(size = 10, color = "black"),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
aa_proportion_missing_plot + coord_cartesian(ylim = c(0, 0.9))
# Variable sites plot - aa
aa_variable_sites_plot <- ggplot(selected_55_aa_sums, aes(trim_method, Proportion_variable_sites)) + 
  geom_boxplot(aes(fct_inorder(trim_method)), fill = "gray95", outlier.size = 1, outlier.shape = 1) +
  labs(x=NULL, y="Prop. of variable sites") +
  scale_y_continuous(n.breaks = 10) +
  theme(axis.text = element_text(size=10, color = "black"),
        axis.title = element_text(size = 10, color = "black"),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
aa_variable_sites_plot
# Parsimony-informative sites plot - aa
aa_pis_plot <- ggplot(selected_55_aa_sums, aes(trim_method, Proportion_parsimony_informative)) + 
  geom_boxplot(aes(fct_inorder(trim_method)), fill = "gray95", outlier.size = 1, outlier.shape = 1) +
  labs(x=NULL, y="Prop. of parsimony-informative sites") +
  scale_y_continuous(n.breaks = 10) +
  theme(axis.text = element_text(size=10, color = "black"),
        axis.title = element_text(size = 10, color = "black"),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
aa_pis_plot
# Alignment length plot - aa
aa_aln_length_plot <- ggplot(selected_55_aa_sums, aes(trim_method, Alignment_length)) + 
  geom_boxplot(aes(fct_inorder(trim_method)), fill = "gray95", outlier.size = 1, outlier.shape = 1) +
  labs(x=NULL, y="Alignment length") +
  scale_y_continuous(n.breaks = 10) +
  theme(axis.text = element_text(size=10, color = "black"),
        axis.title = element_text(size = 10, color = "black"),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
aa_aln_length_plot
# Nucleotides
# Proportion missing plot - na
na_proportion_missing_plot <- ggplot(selected_55_na_sums, aes(trim_method, Missing_percent/100)) + 
  geom_boxplot(aes(fct_inorder(trim_method)), fill = "gray95", outlier.size = 1, outlier.shape = 1) +
  labs(x=NULL, y="Prop. missing") +
  scale_y_continuous(n.breaks = 10) +
  theme(axis.text = element_text(size=10, color = "black"),
        axis.title = element_text(size = 10, color = "black"),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
na_proportion_missing_plot + coord_cartesian(ylim = c(0, 0.9))
# Variable sites plot - na
na_variable_sites_plot <- ggplot(selected_55_na_sums, aes(trim_method, Proportion_variable_sites)) + 
  geom_boxplot(aes(fct_inorder(trim_method)), fill = "gray95", outlier.size = 1, outlier.shape = 1) +
  labs(x=NULL, y="Prop. of variable sites") +
  scale_y_continuous(n.breaks = 10) +
  theme(axis.text = element_text(size=10, color = "black"),
        axis.title = element_text(size = 10, color = "black"),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
na_variable_sites_plot
# Parsimony-informative sites plot - na
na_pis_plot <- ggplot(selected_55_na_sums, aes(trim_method, Proportion_parsimony_informative)) + 
  geom_boxplot(aes(fct_inorder(trim_method)), fill = "gray95", outlier.size = 1, outlier.shape = 1) +
  labs(x=NULL, y="Prop. of parsimony-informative sites") +
  scale_y_continuous(n.breaks = 10) +
  theme(axis.text = element_text(size=10, color = "black"),
        axis.title = element_text(size = 10, color = "black"),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
na_pis_plot
# Alignment length plot - na
na_aln_length_plot <- ggplot(selected_55_na_sums, aes(trim_method, Alignment_length)) + 
  geom_boxplot(aes(fct_inorder(trim_method)), fill = "gray95", outlier.size = 1, outlier.shape = 1) +
  labs(x=NULL, y="Alignment length") +
  scale_y_continuous(n.breaks = 10) +
  theme(axis.text = element_text(size=10, color = "black"),
        axis.title = element_text(size = 10, color = "black"),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
na_aln_length_plot
# Combine panels into Fig 2
figS3 <- ggarrange(aa_proportion_missing_plot, aa_variable_sites_plot, aa_pis_plot, aa_aln_length_plot, 
                  na_proportion_missing_plot, na_variable_sites_plot, na_pis_plot, na_aln_length_plot,
                  nrow = 2, ncol = 4, widths = c(2,2,2,2), heights = c(1,1,1,1))
ggsave(filename = "figS3.pdf", plot = figS3, device = "pdf")