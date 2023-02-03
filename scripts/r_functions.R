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
  n_cat_x <- as.numeric(n_cat_query[lgl] %>% str_replace(pattern = "C", replacement = ""))
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