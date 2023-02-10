#!/bin/bash

mkdir -p analyses/phylonetworks/alignments
mkdir -p analyses/phylonetworks/alignment_summaries
# trim taxa to subsetX and output phylip for pb	
AMAS.py remove -i analyses/L1648/alignments/single/*ng.faa \
 -f fasta -u phylip -d aa -c 12 \
 -x $(cat misc_files/taxa_dropped_subset1.txt) \
 -g analyses/phylonetworks/alignments/
# Fix the file names of the subset 1 alignments
for aln in $(ls analyses/phylonetworks/alignments/*) ; do
 	new_label=$(echo ${aln} | sed 's/.faa-out//' | sed "s/_selected_55/_subset1/")
 	mv ${aln} ${new_label}
done
# Get alignment summary for subset 1 to remove loci with missing taxa
AMAS.py summary -i analyses/phylonetworks/alignments/*.phy \
 -f phylip -d aa -c 14 \
 -o analyses/phylonetworks/alignment_summaries/subset1_ng_aln_aa.summary
