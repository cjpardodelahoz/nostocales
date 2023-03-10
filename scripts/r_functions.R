#!/usr/bin/env Rscript

# Function to read the busco output from a single genome in a run
# sample_id      Name of the genome that matches the output directory of the BUSCO run.
# busco_out_dir  Base path to directory with genome-specific BUSCO output
# busco_db       Name of the BUSCO database used in the run. This is used to build the path to the results E.g., "run_cyanobacteria_odb1o"
# out_file_name  Name of the BUSCO output talbe file. Typically "full_table.tsv".
read_busco <- function(sample_id, busco_out_dir, busco_db, out_file_name) {
  busco_out_file <- paste(busco_out_dir, sample_id, busco_db, out_file_name, sep = "/")
  busco_out <- readr::read_delim(busco_out_file, skip = 2, delim = "\t") %>%
    dplyr::mutate(sample_id = sample_id)
  return(busco_out)
}

# Function to combine the busco output from multiple genomes of the same run into
# a single table
# sample_ids      Character vector with names of the genomes that match the output directory of the BUSCO run.
# busco_out_dir   Base path to directory with genome-specific BUSCO output
# busco_db        Name of the BUSCO database used in the runs. This is used to build the path to the results E.g., "run_cyanobacteria_odb1o"
# out_file_name   Name of the BUSCO output table file. Typically "full_table.tsv".
merge_busco <- function(sample_ids, busco_out_dir, busco_db, out_file_name) {
  busco_out_list <- lapply(sample_ids, read_busco, 
                           busco_out_dir = busco_out_dir, 
                           out_file_name = out_file_name,
                           busco_db = busco_db)
  busco_sum <- dplyr::bind_rows(busco_out_list)
  new_colnames <- stringr::str_remove(colnames(busco_sum), "# ") %>%
    stringr::str_replace(" ", "_") %>%
    stringr::str_to_lower()
  colnames(busco_sum) <- new_colnames
  return(busco_sum)
}

# Function to add paths to complete single copy busco to busco df
# busco_df        Data frame with busco results as obtained with merge_busco()
# busco_out_dir   Base path to directory with genome-specific BUSCO output
# busco_db        Name of the BUSCO database used in the runs. This is used to build the path to the results E.g., "run_cyanobacteria_odb1o"
add_busco_paths <- function(busco_df, busco_out_dir, busco_db) {
  seq_base_path <- c("busco_sequences/single_copy_busco_sequences")
  busco_df_paths <- busco_df %>%
    filter(status == "Complete") %>%
    dplyr::mutate(na_seq_path =
             paste(busco_out_dir, "/", sample_id, 
                   "/", busco_db, "/", 
                   seq_base_path, "/",
                   busco_id, ".fna", sep = "")
    ) %>%
    dplyr::mutate(aa_seq_path =
             paste(busco_out_dir, "/", sample_id, 
                   "/", busco_db, "/", 
                   seq_base_path, "/",
                   busco_id, ".faa", sep = "")
    )
  return(busco_df_paths)
}

# Function to add seq labels to the filtered busco df
# busco_df_paths  Data frame with busco results after paths have been added with add_busco_paths()
add_busco_labels <- function(busco_df_paths) {
  paths <- busco_df_paths %>%
    pull(na_seq_path)
  seq_label <- lapply(paths, ape::read.FASTA) %>%
    lapply(., names) %>%
    unlist()
  busco_df_paths_labels <- busco_df_paths %>%
    tibble::add_column(seq_label)
  return(busco_df_paths_labels)
}

# Function to generate multifasta file for one busco locus
# busco                   ID of a single busco locus
# busco_df_paths_labels   Data frame with busco results after paths and labels have been added with add_busco_paths() and add_busco_labels()
# data_type               "DNA" or "AA"
# out_dir                 Path to directory to write the multifasta file
cat_busco_seqs <- function(busco, busco_df_paths_labels, data_type, out_dir) {
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = T)
  }
  filtered_df <- busco_df_paths_labels %>%
    dplyr::filter(busco_id == busco)
  ref_table <- filtered_df %>%
    dplyr::select(seq_label, sample_id)
  if (data_type == "DNA") {
    path_file <- paste(out_dir, "/", busco, "_na_paths", sep = "")
    tmp_file <- paste(out_dir, "/", busco, ".fna.tmp", sep = "")
    seq_file <- paste(out_dir, "/", busco, ".fna", sep = "")
    cat_commnad <- paste("cat $(cat ", path_file, ") > ", 
                         tmp_file, sep = "")
    rm_commnad1 <- paste("rm ", out_dir, "/", "*_na_paths", sep = "")
    rm_commnad2 <- paste("rm ", out_dir, "/", ".fna", sep = "")
    filtered_df %>%
      dplyr::pull(na_seq_path) %>%
      write(path_file)
    system(cat_commnad)
    phylotools::rename.fasta(infile = tmp_file, 
                             ref_table = ref_table, 
                             outfile = seq_file)
  } else {
    path_file <- paste(out_dir, "/", busco, "_aa_paths", sep = "")
    tmp_file <- paste(out_dir, "/", busco, ".faa.tmp", sep = "")
    seq_file <- paste(out_dir, "/", busco, ".faa", sep = "")
    cat_commnad <- paste("cat $(cat ", path_file, ") > ", 
                         tmp_file, sep = "")
    filtered_df %>%
      dplyr::pull(aa_seq_path) %>%
      write(path_file)
    system(cat_commnad)
    phylotools::rename.fasta(infile = tmp_file, 
                             ref_table = ref_table, 
                             outfile = seq_file)
  }
}

# Function to generate multifasta files for all busco loci across all taxa
# This is a wrapper for the full pipeline
# sample_ids      Text file with a list of the names of the genome samples. This should match the names of the sample-specific directories that contain the busco output
# busco_out_dir   Base path to directory with genome-specific BUSCO output
# busco_db        Name of the BUSCO database used in the runs. This is used to build the path to the results E.g., "run_cyanobacteria_odb1o"
# out_file_name   Name of the file with the raw busco output. Typically "full_table.tsv"
# data_type       "DNA" or "AA". Make sure that busco outputs the data type that you want to consolidate.
# out_dir         Path to directory to write the multifasta files
# busco_ids_file  Path to the file where you want the output file with the list of busco ids that were processed.
sort_busco_seqs <- function(sample_ids, busco_out_dir, busco_db, out_file_name,
                            data_type, out_dir, busco_ids_file) {
  rm_commnad1 <- paste("rm ", out_dir, "/", "*_paths", sep = "")
  rm_commnad2 <- paste("rm ", out_dir, "/", "*.tmp", sep = "")
  busco_df <- merge_busco(sample_ids = sample_ids, 
                          busco_out_dir = busco_out_dir, 
                          busco_db = busco_db, 
                          out_file_name = out_file_name) %>% 
    add_busco_paths(busco_out_dir = busco_out_dir, busco_db = busco_db) %>%
    add_busco_labels()
  busco_ids <- busco_df %>%
    dplyr::pull(busco_id) %>%
    unique()
  output <- lapply(busco_ids, cat_busco_seqs, 
                   busco_df_paths_labels = busco_df,
                   data_type = data_type,
                   out_dir = out_dir)
  if (!file.exists(busco_ids_file)) {
    write(busco_ids, file = busco_ids_file)
  }
  system(rm_commnad1)
  system(rm_commnad2)
}

# Function to get the number of profile mixture categories (C10-C60) from 
# an iqtree model string (e.g, "LG+C60+F+R4"). Returns NA if model is site-homogeneous
get_n_cat <- function(x) {
  n_cat_query <- c("C10", "C20", "C30", "C40", "C50", "C60")
  lgl <- map_lgl(n_cat_query, str_detect, string = x)
  n_cat_x <- n_cat_query[lgl]
  ifelse(length(n_cat_x) == 0, return(NA), return(n_cat_x)) 
}

# Function to import the model finder output tables, atomize the model information into 
# multiple columns, and joins them all into a single data frame
# mf_path     path to directory with mf output files
# aln_filter  alignment filter code
# suffix      characters between the locus code and the aln filter code, e.g., "_selected_55_aa_"
# madd        additional site-heterogeneous models evaluted and included in the mf output
model_finder_df <- function(mf_path, aln_filter, suffix, madd) {
  # get at list of mf output file names
  mf_files <- list.files(path = mf_path, pattern = paste(aln_filter, "\\.mf", sep = ""),
                         full.names = T, recursive = F)
  # list to store mf tables
  mf_list <- list()
  # Loop through file names
  for (i in 1:length(mf_files)) {
    # get the ith file name
    mf_file <- mf_files[i]
    # load the table into the list
    mf_list[[i]] <- read.delim(mf_file, header = F, sep = "")
    # add headers
    colnames(mf_list[[i]]) <- c("No.", "Model", "negative_LnL", "df", "AIC", "AICc", "BIC") 
    # add column with model type
    mf_list[[i]]$model_type <- ifelse(mf_list[[i]]$Model %in% madd, "shet", "sho")
    # add column with exchangeabily matrix
    mf_list[[i]]$matrix <- gsub("\\+.*", "", mf_list[[i]]$Model)
    # add column with rate heterogeneity parameter
    free_rate <- grep("R", mf_list[[i]]$Model, value = T, ignore.case = F)                # Models that have FreeRate parameter
    gamma4 <- grep("G4", mf_list[[i]]$Model, value = T, ignore.case = F) %>%              # Models that have the G4 paramenter
      setdiff(grep("LG4", mf_list[[i]]$Model, value = T, ignore.case = F))
    mf_list[[i]]$rates <- ifelse(mf_list[[i]]$Model %in% free_rate, "free_rate",
                                 ifelse(mf_list[[i]]$Model %in% gamma4, "gamma", "none"))
    # add column with the alignment filter code
    mf_list[[i]]$aln_filter <- aln_filter
    # add column with locus code
    mf_list[[i]]$locus <- str_replace(mf_file, paste(mf_path, "/", sep = ""), "") %>%     # Paste yields e.g "../by_locus_trimmed/modelfinder_out//"
      str_replace(paste(suffix, aln_filter, "\\.mf", sep = ""), "")                       # Paste yields e.g "_selected_55_aa_kcg.mf"
    # add column with file name of mf output
    mf_list[[i]]$file_name <- str_replace(mf_file, paste(mf_path, "/", sep = ""), "")     # Paste yields e.g."../by_locus_trimmed/modelfinder_out//"
    # Add column with number of profile mixture categories
    mf_list[[i]] <- mutate(mf_list[[i]],
                           n_cat = map_chr(Model, get_n_cat))
    # add column with logical indicating whether model is the best according to BIC
    min_bic <- min(mf_list[[i]]$BIC)
    mf_list[[i]]$best_model <- ifelse(mf_list[[i]]$BIC == min_bic, TRUE, FALSE)
    # add column with logical indicating whether sho model is the best according to BIC
    min_bic_sho <- filter(mf_list[[i]], model_type == "sho") %>%  pull(BIC) %>% min()
    if (nrow(filter(mf_list[[i]], BIC == min_bic_sho)) == 1) {
      mf_list[[i]]$best_sho <- ifelse(mf_list[[i]]$BIC == min_bic_sho, TRUE, FALSE)
    } else {
      min_df_sho <- filter(mf_list[[i]], BIC == min_bic_sho) %>% pull(df) %>% min()
      mf_list[[i]]$best_sho <- ifelse(mf_list[[i]]$BIC == min_bic_sho & mf_list[[i]]$df == min_df_sho, 
                                      TRUE, FALSE)
    }
    # add column with logical indicating whether shet model is the best according to BIC
    min_bic_shet <- filter(mf_list[[i]], model_type == "shet") %>%  pull(BIC) %>% min()
    if (nrow(filter(mf_list[[i]], BIC == min_bic_shet)) == 1) {
      mf_list[[i]]$best_shet <- ifelse(mf_list[[i]]$BIC == min_bic_shet, TRUE, FALSE)
    } else {
      min_cat_shet <- filter(mf_list[[i]], model_type == "shet" & BIC == min_bic_shet) %>% pull(n_cat) %>% min()
      mf_list[[i]]$best_shet <- ifelse(mf_list[[i]]$BIC == min_bic_shet & mf_list[[i]]$n_cat == min_cat_shet, 
                                       TRUE, FALSE)
    }
  }
  # Append all tables into a single data frame
  mf_df <- bind_rows(mf_list)
  # Remove duplicate model-locus combinations from each data frame
  mf_df <- distinct(mf_df, aln_filter, Model, locus, .keep_all = TRUE)
  # Add logical column indicating whether model has invariant parameter (+I)
  mf_df <- mutate(mf_df,
                  invariant = str_detect(string = Model, pattern = "\\+I"))
  # Add logical column indicating whether model has frequencies parameter (+F)
  mf_df <- mutate(mf_df,
                  frequencies = str_detect(string = Model, pattern = "\\+F"))
  # Change exchangeability matrix names to lower case
  mf_df <- mutate_at(mf_df, "matrix", str_to_lower)
  # Return the data frame
  return(mf_df)
}

# Function to calculate mean bootstrap support
# locus   locus code
# path    path to trees
# suffix  suffix of tree files (e.g. "_selected_55_ng.treefile")
get_mean_bootstrap_single <- function(locus, path, suffix) {
  tree <- read.tree(file = paste(path, locus, suffix, sep = ""))
  mean_ufboot <- tree$node.label %>%
    as.numeric() %>%
    mean(na.rm = T)
}
# Vectorize function
get_mean_bootstrap <- Vectorize(get_mean_bootstrap_single, vectorize.args = "locus")

# Function to replace and condense discovista conflict scoring
# discov_out  A data frame with the raw output table of Discovista conflict analysis
condense_discov_out <- function(discov_out) {
  # Keep only bipartition columns
  discov_new <- select(discov_out, 4:ncol(discov_out))
  # Replace conflict scoring
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Missing", replacement = "uninformative")
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Compatible \\(Weak Rejection\\)", replacement = "uninformative")
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Weak Support", replacement = "uninformative")
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Strong Rejection", replacement = "discordant")
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Strong Support", replacement = "concordant")
  # Make the df
  discov_new <- as.data.frame(discov_new) %>%
    pivot_longer(everything(), names_to = "bipart", values_to = "support") %>%
    count(bipart, support)  %>%
    pivot_wider(names_from = support, values_from = n) %>%
    mutate_if(is.integer, ~replace(., is.na(.), 0)) %>%
    mutate(no_loci =
             rowSums(across(concordant:uninformative))) %>%
    mutate(percent_concordant =
             (concordant/no_loci)*100) %>%
    mutate(percent_discordant = 
             (discordant/no_loci)*100) %>%
    mutate(percent_uninformative = 
             (uninformative/no_loci)*100)
  return(discov_new)
}

# Function to replace and condense discovista conflict scoring keeping weak support category
# discov_out  A data frame with the raw output table of Discovista conflict analysis
condense_discov_out_weak <- function(discov_out) {
  # Keep only bipartition columns
  discov_new <- select(discov_out, 4:ncol(discov_out))
  # Replace conflict scoring
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Missing", replacement = "uninformative")
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Compatible \\(Weak Rejection\\)", replacement = "weak_reject")
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Weak Support", replacement = "weak_support")
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Strong Rejection", replacement = "discordant")
  discov_new <- apply(discov_new, MARGIN = 2, str_replace, pattern = "Strong Support", replacement = "concordant")
  # Make the df
  discov_new <- as.data.frame(discov_new) %>%
    pivot_longer(everything(), names_to = "bipart", values_to = "support") %>%
    count(bipart, support)  %>%
    pivot_wider(names_from = support, values_from = n) %>%
    mutate_if(is.integer, ~replace(., is.na(.), 0)) %>%
    mutate(no_loci =
             rowSums(across(concordant:weak_support))) %>%
    mutate(percent_concordant =
             (concordant/no_loci)*100) %>%
    mutate(percent_discordant = 
             (discordant/no_loci)*100) %>%
    mutate(percent_uninformative = 
             (uninformative/no_loci)*100) %>%
    mutate(percent_weak_reject =
             (weak_reject/no_loci)*100) %>%
    mutate(percent_weak_support =
             (weak_support/no_loci)*100)
  return(discov_new)
}

# Function to generate files with model commands to run PhyloBayes
# mf_path     path to directory with mf output files
# aln_filter  alignment filter code
# suffix      characters between the locus code and the aln filter code, e.g., "_subset1_"
# madd        additional site-heterogeneous models evaluted and included in the mf output
write_pb_command <- function(mf_path, aln_filter, suffix, madd, out_path) {
  # Import and append all mf output tables
  df_mf <- model_finder_df(mf_path, aln_filter, suffix, madd)
  # Filter to best model per locus
  df_mf <- dplyr::filter(df_mf, best_model == TRUE)
  # Add column with phylobayes command-chain 1
  df_mf <- dplyr::mutate(df_mf,
                  pb_command_1 = ifelse(best_shet == TRUE, 
                                        paste("-d", " ", out_path, locus, suffix, aln_filter, ".phy", 
                                              " ", "-catfix ", n_cat, " -", matrix, " -x 5 10000", " ", out_path, locus, suffix, aln_filter, "_c1", sep = ""),
                                        ifelse(rates != "gamma",
                                               paste("-d", " ", out_path, locus, suffix, aln_filter, ".phy", 
                                                     " ", " -", matrix, " -x 5 10000", " ", out_path, locus, suffix, aln_filter, "_c1", sep = ""),
                                               paste("-d", " ", out_path, locus, suffix, aln_filter, ".phy", 
                                                     " ", " -", matrix, " -dgam 4", " -x 5 10000", " ", out_path, locus, suffix, aln_filter, "_c1", sep = ""))))
  # Add column with phylobayes command-chain2
  df_mf <- dplyr::mutate(df_mf,
                  pb_command_2 = ifelse(best_shet == TRUE, 
                                        paste("-d", " ", out_path, locus, suffix, aln_filter, ".phy", 
                                              " ", "-catfix ", n_cat, " -", matrix, " -x 5 10000", " ", out_path, locus, suffix, aln_filter, "_c2", sep = ""),
                                        ifelse(rates != "gamma",
                                               paste("-d", " ", out_path, locus, suffix, aln_filter, ".phy", 
                                                     " ", " -", matrix, " -x 5 10000", " ", out_path, locus, suffix, aln_filter, "_c2", sep = ""),
                                               paste("-d", " ", out_path, locus, suffix, aln_filter, ".phy", 
                                                     " ", " -", matrix, " -dgam 4", " -x 5 10000", " ", out_path, locus, suffix, aln_filter, "_c2", sep = ""))))
  # write the command file for each locus
  for (locus in df_mf$locus) {
    command_1 <- df_mf$pb_command_1[df_mf$locus == locus]                                   # Extract the pb command for the given locus
    command_2 <- df_mf$pb_command_2[df_mf$locus == locus] 
    file_name_1 <- paste(out_path, locus, suffix, aln_filter, "_c1", ".pb", sep = "")       # Assemble file name
    file_name_2 <- paste(out_path, locus, suffix, aln_filter, "_c2", ".pb", sep = "")
    write(command_1, file = file_name_1)                                                    # Save the file to out_path
    write(command_2, file = file_name_2)
  }
}

# Function to get random sample of loci names
# size        number of loci to sample
# reps        number of replicate samples to get
# loci_names  pool of loci names to sample from
sample_loci_single <- function(size, reps, loci_names, path, prefix, suffix) {
  # Get matrix with random samples of loci 
  rloci_sets <- replicate(reps, sample(loci_names, size))
  # Write each random sample (column in the matrix) into a file
  for (rep in 1:reps) {
    file_name <- paste(path, size, "_rep", rep, sep = "")         # file name for each sample (column of the matrix), e.g., "31_rep1"
    rloci_set <- rloci_sets[ ,rep] %>%
      paste(suffix, sep = "") %>%
      paste(prefix, ., sep = "")
    write(rloci_set, file = file_name)
  }
}

# Wrapper function for "sample_loci_single" to get random samples of different numbers of loci names
# size_seq    sequence of number of loci to sample
# reps        number of replicate samples to get
# loci_names  pool of loci names to sample from
# path        output path
# prefix      path to alignment file
# suffix      characters after locus code in alignment file names
sample_loci_seq <- function(size_seq, reps, loci_names, path, prefix, suffix) {
  lapply(size_seq, sample_loci_single, reps = reps, loci_names = loci_names, 
         path = path, prefix = prefix, suffix = suffix)
}


# Function to test whether all bipartitions in a tree are highly supported
# tree_file     path to the tree file
# cutoff        suport value cutoff
# tips_to_drop  Optional. Vector of tip labels to drop before evaluating support
test_support_scalar <- function(tree_file, cutoff, tips_to_drop) {
  # load tree
  tree <- ape::read.tree(file = tree_file)
  # if user does not provide taxa to trim
  if (length(tips_to_drop) == 0) {
    supported <- tree$node.label[tree$node.label != ""] %>%                   # remove empty support values
      as.numeric() >= cutoff                                                  # convert to numeric and check which support values are higher than the threshold
    all_supported <- all(supported)                                           # remove empty support values and check which are higher than the threshold
    return(all_supported)
    # if user provides taxa to trim
  } else {
    subtree <- ape::drop.tip(tree, tips_to_drop)                                   # trim specified taxa
    supported <- subtree$node.label[subtree$node.label != ""] %>%             # remove empty support values 
      as.numeric() >= cutoff                                                  # convert to numeric and check which are higher than the threshold
    all_supported <- all(supported)                                           # check if all support values are higher than the threshold
    return(all_supported)
  }
}
# Vectorize test_support_scalar
test_support_vect <- Vectorize(FUN = test_support_scalar, vectorize.args = "tree_file", USE.NAMES = F)

# Function to count the number of distinct supported trees
# no_loci       column with number of loci used
# file_names    vector with paths to treefiles
# cutoff        UFBoot threshold
# tips_to_drop  Vector of taxa names to drop to get the subtrees that will be evaluated
count_distinct_supported_trees <- function(no_loci, file_names, cutoff, tips_to_drop) {
  # Make regex to query trees from a given number of loci
  pattern <- paste(".*/", no_loci, "_rep.*", sep = "")
  # Get the paths of all the trees of a given number of loci
  no_loci_filenames <- file_names[stringr::str_detect(file_names, pattern)]
  # Test which trees are fully supported supported
  supported_lgl <- test_support_vect(no_loci_filenames, cutoff = cutoff, tips_to_drop = tips_to_drop)
  # Get names of fuly supported trees
  supported_filenames <- no_loci_filenames[supported_lgl]
  # Read fully supported trees
  trees <- lapply(supported_filenames, ape::read.tree)
  # Trim specified taxa from trees to get subtrees of interest
  trimmed_trees <- lapply(trees, ape::drop.tip, tip = tips_to_drop)
  # Convert list of trees to multiPhylo object to manipulate with ape
  class(trimmed_trees) <- "multiPhylo"
  # Make sure trees are unrooted
  trimmed_trees <- ape::unroot.multiPhylo(trimmed_trees)
  # If there is only one fully supported tree, return 1
  if (length(trimmed_trees) == 1) {
    n_distinct_supported_trees <- 1
    # Otherwise, calculate RF distances among trees, cluster the trees according to pairwise distance, 
    # cut the tree with threshold of 0 to get unique trees and count them
  } else {
    rf_distances <- ape::dist.topo(trimmed_trees)
    n_distinct_supported_trees <- rf_distances %>%
      hclust() %>%
      cutree(h = 0) %>%
      max()
  }
  return(n_distinct_supported_trees)
}
# Vectorize no_loci argument of the function
count_distinct_supported_trees_vect <- Vectorize(count_distinct_supported_trees, vectorize.args = "no_loci")
