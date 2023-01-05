#!/bin/bash

# This is a script to subsample the 6 alignments used for a test run of the Ne analysis

# Remove the taxa not present in clades 
AMAS.py remove -i analyses/ancestral_ne/test_run/seqs/*.fna -f fasta -d dna \
 -x $(cat scripts/taxa_dropped_subset2.txt) \
 --out-prefix analyses/ancestral_ne/test_run/seqs/
# Modify filenames
for aln in $(ls analyses/ancestral_ne/test_run/seqs/*-out.fas) ; do
 mv ${aln} ${aln%_selected_55_ng.fna-out.fas}_subset2.fna
done

