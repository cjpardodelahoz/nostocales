#!/bin/bash

# Subset all 1648 loci alignments to taxa in subset 1
AMAS.py remove -i analyses/L1648/alignments/single/*ng.faa -f fasta -d aa \
 -x $(cat misc_files/taxa_dropped_subset1.txt) \
 -u phylip -g analyses/phylogenomic_jackknifing/alignments/single/ -c 12
# remove .faa-out from file labels and replace slected_55 with subset1
for old in $(ls analyses/phylogenomic_jackknifing/alignments/single/*) ; do 
  new=$(echo ${old} | sed 's/.faa-out//' | sed 's/selected_55/subset1/')
  mv ${old} ${new}
done
# concatenate aa sampled alignments from taxa subset 1
mkdir -p analyses/phylogenomic_jackknifing/alignments/concat
for samp in $(ls analyses/phylogenomic_jackknifing/loci_samples/) ; do
  AMAS.py concat -i $(cat analyses/phylogenomic_jackknifing/loci_samples/${samp}) \
  -f phylip -d aa \
  -p analyses/phylogenomic_jackknifing/alignments/concat/part -u phylip \
  --concat-out analyses/phylogenomic_jackknifing/alignments/concat/${samp}.phy 
done
# remove partition file
rm analyses/phylogenomic_jackknifing/alignments/concat/part
