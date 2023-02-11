#!/usr/bin/env Rscript

# Load required libraries and functions
library(tidyverse)
library(RColorBrewer)
library(ape)
source("scripts/r_functions.R")

# Compare and cluster all trees to evaluate topologies ALONG anomaly zone

# Create vector with taxa to drop for evaluating boostrap on anomaly zone internodes
tips_to_drop_azone <- c("Rivularia_sp_PCC_7116", "Chroococcidiopsis_thermalis_PCC_7203", "Peltula.bin.10", 
                        "Scytonema_sp_HK_05_v2", "Fischerella_sp_PCC_9605", "Anabaena_cylindrica_PCC_7122")
# Get list of pmsf concat tree files
bootrare_tree_filenames <- list.files(path = "analyses/phylogenomic_jackknifing/trees", pattern = "pmsf.treefile", full.names = T)
# Test which trees are fully supported supported
supported_lgl_azone <- test_support_vect(bootrare_tree_filenames, cutoff = 95, tips_to_drop = tips_to_drop_azone)
# Get names of fully supported trees
supported_filenames_azone <- bootrare_tree_filenames[supported_lgl_azone]
# Read fully supported trees
trees_azone <- lapply(supported_filenames_azone, read.tree)
# Name trees with file names
names(trees_azone) <- supported_filenames_azone
# Trim specified taxa from trees to get subtrees of interest
trimmed_trees_azone <- lapply(trees_azone, drop.tip, tip = tips_to_drop_azone)
# Convert list of trees to multiPhylo object to manipulate with ape
class(trimmed_trees_azone) <- "multiPhylo"
# Make sure trees are unrooted
trimmed_trees_azone <- unroot.multiPhylo(trimmed_trees_azone)
# Calculate RF distances among all trees
rf_distances_azone <- dist.topo(trimmed_trees_azone)
# Group trees with identical topologies and make it a tibble
clustered_trees_azone_df <- rf_distances_azone %>%
  hclust() %>%
  cutree(h = 0) %>%
  enframe(name = "tree_filenames", value = "topology_id") 

# Build data frames with results WITHIN anomaly zone

# Build data frame with trees as entries
bootrare_trees_azone_df <- tibble(bootrare_tree_filenames) %>%                    # make first df column with tree file names
  rename(tree_filenames = bootrare_tree_filenames) %>%
  mutate(no_loci = 
           str_remove(tree_filenames, "analyses/phylogenomic_jackknifing/trees/") %>%
           str_remove("_rep.*")) %>%                                  # add column with no of concat loci
  mutate(rep = 
           str_remove(tree_filenames, ".*rep") %>%
           str_remove("_pmsf.*")) %>%                                 # add column with replicate number
  mutate(all_supported = 
           test_support_vect(tree_filenames, cutoff = 95, tips_to_drop = tips_to_drop_azone)) %>%    # score whether all internodes are supported
  left_join(clustered_trees_azone_df, by = "tree_filenames")
# Build pivot data frame with number of loci as entry
bootrare_nloci_azone_df <- bootrare_trees_azone_df %>%
  group_by(no_loci) %>%
  count(all_supported) %>%                                            # Count number of trees with all supported for every number of loci
  pivot_wider(names_from = all_supported, values_from = n) %>%
  rename(supported = "TRUE") %>%
  rename(not_supported = "FALSE") %>%
  mutate_if(is.integer, ~replace(., is.na(.), 0)) %>%
  mutate(percent_supported =
           (supported/(supported + not_supported))*100) %>%                 # calculate proportion of supported trees
  mutate(no_loci =
           as.numeric(no_loci)) %>%
  arrange(no_loci) %>%
  mutate(no_distinct_supported_trees =                                # count number of distinct supported subtrees at each nloci point
           count_distinct_supported_trees_vect(no_loci = no_loci, file_names = bootrare_tree_filenames, 
                                               cutoff = 95, tips_to_drop = tips_to_drop_azone))

# Compare and cluster all trees to evaluate topologies OUTISDE of anomaly zone

# Create vector with taxa to drop for evaluating boostrap on anomaly zone internodes
tips_to_drop_nozone <- c("Fortiea_contorta_PCC_7126", "JL23bin6", "Anabaena_cylindrica_PCC_7122", 
                         "Cylindrospermum_stagnale_PCC_7417", "Nodularia_sp_NIES_3585")
# Test which trees are fully supported supported
supported_lgl_nozone <- test_support_vect(bootrare_tree_filenames, cutoff = 95, tips_to_drop = tips_to_drop_nozone)
# Get names of fully supported trees
supported_filenames_nozone <- bootrare_tree_filenames[supported_lgl_nozone]
# Read fully supported trees
trees_nozone <- lapply(supported_filenames_nozone, read.tree)
# Name trees with file names
names(trees_nozone) <- supported_filenames_nozone
# Trim specified taxa from trees to get subtrees of interest
trimmed_trees_nozone <- lapply(trees_nozone, drop.tip, tip = tips_to_drop_nozone)
# Convert list of trees to multiPhylo object to manipulate with ape
class(trimmed_trees_nozone) <- "multiPhylo"
# Make sure trees are unrooted
trimmed_trees_nozone <- unroot.multiPhylo(trimmed_trees_nozone)
# Calculate RF distances among all trees
rf_distances_nozone <- dist.topo(trimmed_trees_nozone)
# Group trees with identical topologies and make it a tibble
clustered_trees_nozone_df <- rf_distances_nozone %>%
  hclust() %>%
  cutree(h = 0) %>%
  enframe(name = "tree_filenames", value = "topology_id") 

# Build data frames with results OUTSIDE of anomaly zone

# Build data frame with trees as entries
bootrare_trees_nozone_df <- tibble(bootrare_tree_filenames) %>%                    # make first df column with tree file names
  rename(tree_filenames = bootrare_tree_filenames) %>%
  mutate(no_loci = 
           str_remove(tree_filenames, "analyses/phylogenomic_jackknifing/trees/") %>%
           str_remove("_rep.*")) %>%                                  # add column with no of concat loci
  mutate(rep = 
           str_remove(tree_filenames, ".*rep") %>%
           str_remove("_pmsf.*")) %>%                                 # add column with replicate number
  mutate(all_supported = 
           test_support_vect(tree_filenames, cutoff = 95, tips_to_drop = tips_to_drop_nozone)) %>%    # score whether all internodes are supported
  left_join(clustered_trees_nozone_df, by = "tree_filenames")
# Build pivot data frame with number of loci as entry
bootrare_nloci_nozone_df <- bootrare_trees_nozone_df %>%
  group_by(no_loci) %>%
  count(all_supported) %>%                                            # Count number of trees with all supported for every number of loci
  pivot_wider(names_from = all_supported, values_from = n) %>%
  rename(supported = "TRUE") %>%
  rename(not_supported = "FALSE") %>%
  mutate_if(is.integer, ~replace(., is.na(.), 0)) %>%
  mutate(percent_supported =
           (supported/(supported + not_supported))*100) %>%                 # calculate proportion of supported trees
  mutate(no_loci =
           as.numeric(no_loci)) %>%
  arrange(no_loci) %>%
  mutate(no_distinct_supported_trees =                                # count number of distinct supported subtrees at each nloci point
           count_distinct_supported_trees_vect(no_loci = no_loci, file_names = bootrare_tree_filenames, 
                                               cutoff = 95, tips_to_drop = tips_to_drop_nozone))

# Let's make Fig 5

# Proportion of trees (all loci) with all anomaly zone internodes supported
fig5b <- bootrare_nloci_azone_df %>%
  ggplot(aes(x = no_loci, y = percent_supported)) +
  geom_line() +
  geom_point() +
  labs(x = "No. of loci", y = "% of fully supported trees") +
  scale_x_continuous(breaks = c(31, 131, 331, 531, 731, 1131)) +
  theme(axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12, colour = "black"),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 2/3)
ggsave(plot = fig5b, "Fig5b.pdf", device = "pdf")
# Distribution of distinct topologies across number of loci
get_palette <- colorRampPalette(brewer.pal(12, "Paired"))   # function to expand color palette
fig5c <- bootrare_trees_azone_df %>%
  filter(all_supported == T) %>%
  ggplot(aes(no_loci)) +
  geom_bar(aes(fill = factor(topology_id))) +
  scale_fill_manual(values = get_palette(17),
                    name = "Topology") +
  aes(fct_relevel(no_loci, "31", "51", "71", "91", "111", "131", "331", "531", "731", "1131")) +
  labs(x = "No. of loci", y = "Topology frequency") +
  theme(axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12, colour = "black"),
        legend.text = element_text(size = 12, colour = "black"),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        aspect.ratio = 2/3) +
  guides(fill=guide_legend(ncol = 2))
ggsave(plot = fig5c, "Fig5c.pdf", device = "pdf")
# Proportion of trees (all loci) with non-anomaly zone internodes supported
fig5e <- bootrare_nloci_nozone_df %>%
  ggplot(aes(x = no_loci, y = percent_supported)) +
  geom_line() +
  geom_point() +
  labs(x = "No. of loci", y = "% of fully supported trees") +
  scale_x_continuous(breaks = c(31, 131, 331, 531, 731, 1131)) +
  scale_y_continuous(limits = c(0,100)) +
  theme(axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12, colour = "black"),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        legend.position = "none",
        aspect.ratio = 2/3)
ggsave(plot = fig7e, "Fig5e.pdf", device = "pdf")
# Distribution of distinct topologies across number of loci
get_palette <- colorRampPalette(brewer.pal(12, "Set3"))   # function to expand color palette
fig5f <- bootrare_trees_nozone_df %>%
  filter(all_supported == T) %>%
  ggplot(aes(no_loci)) +
  geom_bar(aes(fill = factor(topology_id))) +
  scale_fill_manual(values = get_palette(17),
                    name = "Topology") +
  aes(fct_relevel(no_loci, "31", "51", "71", "91", "111", "131", "331", "531", "731", "1131")) +
  scale_y_continuous(limits = c(0,50)) +
  labs(x = "No. of loci", y = "Topology frequency") +
  theme(axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12, colour = "black"),
        legend.text = element_text(size = 12, colour = "black"),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        panel.background = element_blank(),
        aspect.ratio = 2/3) +
  guides(fill=guide_legend(ncol = 2))
ggsave(plot = fig5f, "Fig5f.pdf", device = "pdf")