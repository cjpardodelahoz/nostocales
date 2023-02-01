#!/usr/bin/env Rscript

# This script was used to generate Fig. S4.
# We performed model selection analyses with ModelFinder within IQ-Tree v1.6.12 
# and allowed the program to test 20 site-heterogeneous models with empirical 
# profile mixtures in addition to all the site-homogeneous models available. 
# To determine which type of model was a better fit, we calculated the 
# difference in Bayesian Information Criterion (BIC) of the best site-homogeneous
# and the best site-heterogeneous model for each alignment. 
# If the difference is positive, this indicates that the site-heterogeneous
# model is better. 

# Libraries and custom functions
library(tidyverse)
source("scripts/r_functions.R")
# Load file with site heterogenous modes evaluated (madd)
madd <- read.csv("misc_files/madd", check.names = F) %>% colnames()
# Import the model finder output tables for each locus, atomize the model 
# information into multiple columns, and join them all into a single data frame.
# This function will also use the BIC to determine if a model was the best 
# site-heterogeneous (best_shet) or the best site-homogeneous (best_sho) model 
# for each locus.
# See scripts/r_functions.R for info on model_finder_df()
kcg_mf <- model_finder_df(mf_path = "analyses/L1648/modelfinder_out/", 
                          aln_filter = "kcg", suffix = "_selected_55_aa_", 
                          madd = madd)
kcg2_mf <- model_finder_df(mf_path = "analyses/L1648/modelfinder_out/", 
                           aln_filter = "kcg2", suffix = "_selected_55_aa_", 
                           madd = madd)
strict_mf <- model_finder_df(mf_path = "analyses/L1648/modelfinder_out/", 
                             aln_filter = "strict", suffix = "_selected_55_aa_",
                             madd = madd)
ng_mf <- model_finder_df(mf_path = "analyses/L1648/modelfinder_out/", 
                         aln_filter = "ng", suffix = "_selected_55_aa_", 
                         madd = madd)
# Append all data frames
full_mf <- bind_rows(kcg_mf, kcg2_mf, strict_mf, ng_mf)
# Get separate dfs with best shet and sho models 
best_shet <- filter(full_mf, best_shet == TRUE)
best_sho <- filter(full_mf, best_sho == TRUE)
# Add "shet" or "sho" to col names to the two dfs respectively
best_shet <- rename_with(best_shet, str_c, ... = "_shet")
best_sho <- rename_with(best_sho, str_c, ... = "_sho")
# Join the two dfs to get a table where each locus is a single entry with mf results
full_mf_by_locus <- inner_join(best_shet, best_sho, by = c("file_name_shet" = "file_name_sho"))
# Extract the unique columns and rename columns
light_mf_by_locus <- select(full_mf_by_locus, locus_shet, aln_filter_shet, Model_shet, BIC_shet, Model_sho, BIC_sho)
light_mf_by_locus <- rename(light_mf_by_locus, locus = locus_shet, aln_filter = aln_filter_shet)
# Add column with the BIC difference between shet and sho models (BIC_sho - BIC_shet)
light_mf_by_locus <- mutate(light_mf_by_locus,
                            bic_difference = BIC_sho - BIC_shet)
# Add column indicating which model type has best fit
light_mf_by_locus <- mutate(light_mf_by_locus,
                            best_model_type = ifelse(bic_difference > 1, "shet", "sho"))

# LET'S MAKE FIG S4

# Filter light df to mf results for ng filter
light_mf_by_locus_ng <- filter(light_mf_by_locus, aln_filter == "ng")
# Plot BIC difference - L1648+ng
bic_diff_plot <- ggplot(light_mf_by_locus_ng, aes(locus, y = bic_difference)) +
  geom_bar(stat = 'identity', aes(fill = best_model_type)) +
  aes(x = fct_reorder(locus, bic_difference, .desc = T)) +
  scale_fill_brewer(palette = "Set2") +
  coord_cartesian(ylim = c(-100, 2400)) +
  labs(x = "L1648+ng loci", y = "BIC difference (site-homo - site-hete)") +
  scale_y_continuous(n.breaks = 15) +
  scale_x_discrete(expand = expansion(add = 20)) +
  theme(axis.text = element_text(size = 24, colour = "black"),
        axis.title = element_text(size = 24, colour = "black"),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 1)
ggsave(bic_diff_plot, file = "figS4.pdf", device = "pdf")