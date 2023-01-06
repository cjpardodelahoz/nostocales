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