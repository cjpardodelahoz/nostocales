#!/usr/bin/env Rscript

# Load libraries and required functions
library(tidyverse)
library(ggpubr)

# read in MCMC trace files
absolute2_mcmc1 <- read.table("analyses/divtime/mcmc/c1/mcmc_c1.txt", head=TRUE)
absolute2_mcmc2 <- read.table("analyses/divtime/mcmc/c2/mcmc_c2.txt", head=TRUE)
absolute2_mcmc3 <- read.table("analyses/divtime/mcmc/c3/mcmc_c3.txt", head=TRUE)
absolute2_prc1 <- read.table("analyses/divtime/prior/c1/mcmc_pr_c1.txt", head=TRUE)
absolute2_prc2 <- read.table("analyses/divtime/prior/c2/mcmc_pr_c2.txt", head=TRUE)
absolute2_prc3 <- read.table("analyses/divtime/prior/c3/mcmc_pr_c3.txt", head=TRUE)

# each data frame contains 15 columns:
# MCMC generation number, 11 node ages (divergence times), mean mutation rate,
# rate drift coefficient, and sample log-likelihood values
names(absolute2_mcmc1)

# to check for convergence of the MCMC runs, we calculate the posterior
# means of times for each run, and plot them against each other
t.mean1 <- apply(absolute2_mcmc1[,2:12], 2, mean) * 100
t.mean2 <- apply(absolute2_mcmc2[,2:12], 2, mean) * 100
t.mean3 <- apply(absolute2_mcmc3[,2:12], 2, mean) * 100
# good convergence is indicated when the points fall on the y = x line.

par(mfrow=c(2,2))
# posterior times for run 1 vs run 2 vs run 3 (plots for Fig S5:
plot(t.mean1, t.mean2, main="a) Posterior times, c1 vs. c2"); abline(0, 1)
plot(t.mean1, t.mean3, main="a) Posterior times, c1 vs. c3"); abline(0, 1)
plot(t.mean2, t.mean3, main="a) Posterior times, c3 vs. c2"); abline(0, 1)

# we can calculate the effective sample sizes (ESS) of the parameters
# (you need to have the coda package installed for this to work)
mean.mcmc <- apply(absolute2_mcmc1[,-1], 2, mean)
ess.mcmc <- apply(absolute2_mcmc1[,-1], 2, coda::effectiveSize)
var.mcmc <- apply(absolute2_mcmc1[,-1], 2, var)
se.mcmc <- sqrt(var.mcmc / ess.mcmc)
cbind(mean.mcmc, ess.mcmc, var.mcmc, se.mcmc)

# Radiation prior and posterior density - FIG 4b-c

# Let's make a df with the mcmc sample for div times only
absolute2_full_mcmc <- bind_rows(absolute2_mcmc1, absolute2_mcmc2, absolute2_mcmc3)
absolute2_divtimes_post <- select(absolute2_full_mcmc, 2:12)
absolute2_full_prior <- bind_rows(absolute2_prc1, absolute2_prc2, absolute2_prc3)
absolute2_divtimes_prior <- select(absolute2_full_prior, 2:12)
# Tidy data
absolute2_divtimes_post <- pivot_longer(absolute2_divtimes_post, 
                                        cols = colnames(absolute2_divtimes_post), 
                                        names_to = "node", values_to = "age")
absolute2_divtimes_prior <- pivot_longer(absolute2_divtimes_prior, 
                                         cols = colnames(absolute2_divtimes_prior), 
                                         names_to = "node", values_to = "age")

# Plot posterior age density for nodes t_n16-t_n21

# Define color fills for the nodes of interest
node_colors <- c("t_n15" = "gray70", "t_n16" = "gray70", "t_n17" = "gray70", "t_n18" = "gray70", "t_n19" = "gray70", "t_n20" = "gray70", "t_n21" = "gray70")
# Plot prior age density
figxb <- filter(absolute2_divtimes_prior, node %in% c("t_n15","t_n16", "t_n17", "t_n18", "t_n19", "t_n20", "t_n21")) %>%
  ggplot(aes(age)) +
  geom_density(aes(fill = factor(node), alpha = 0.8)) +
  labs(x = "Relative node age", y = "Prior density") +
  scale_fill_manual(values = node_colors) +
  coord_cartesian(xlim = c(2.5,0)) +
  scale_x_continuous(trans = "reverse") +
  scale_y_continuous(limits = c(0, 6.5)) +
  theme(axis.text = element_text(size = 18, color = "black"),
        axis.title = element_text(size = 18, colour = "black"),
        legend.position = "none",
        panel.background = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        aspect.ratio = 2/4)
# Plot posterior age density
figxc <- filter(absolute2_divtimes_post, node %in% c("t_n15", "t_n16", "t_n17", "t_n18", "t_n19", "t_n20", "t_n21")) %>%
  ggplot(aes(age)) +
  geom_density(aes(fill = factor(node), alpha = 0.8)) +
  labs(x = "Relative node age", y = "Posterior density") +
  scale_fill_manual(values = node_colors) +
  coord_cartesian(xlim = c(2.5,0)) +
  scale_x_continuous(trans = "reverse") +
  scale_y_continuous(limits = c(0, 6.5)) +
  theme(axis.text = element_text(size = 18, color = "black"),
        axis.title = element_text(size = 18, colour = "black"),
        legend.position = "none",
        panel.background = element_blank(),
        panel.border = element_rect(fill = NA, color = "black", size = 1),
        aspect.ratio = 2/4)
# Arrage Fig 7b,c
fig4bc <- ggarrange(figxb, figxc, nrow = 2, ncol = 1)
ggsave(fig4bc, filename = "fig4bc.pdf")
