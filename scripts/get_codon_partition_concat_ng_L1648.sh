#!/bin/bash

# generate codon partition file from gene partition file - ng
for line in $(sed 's/\ /./g' analyses/L1648/alignments/concat/na/ng_na_Gpart) ; do
# get the locus name from the partition definition line
	locus=$(echo ${line} | grep -e "DNA" | awk -F'[.]' '{print $2}')
# get first and last position of the gene in the concatenated alignment
	start=$(echo ${line} | grep -e "DNA" | awk -F'[.]' '{print $4}' | awk -F'[-]' '{print $1}')
	fin=$(echo ${line} | grep -e "DNA" | awk -F'[.]' '{print $4}' | awk -F'[-]' '{print $2}')
# write line for 1st, 2nd and 3rd codon position
	printf "DNA, 1st_${locus} = ${start}-${fin}\n"
	printf "DNA, 2nd_${locus} = $(($start + 1))-${fin}\n"
	printf "DNA, 3rd_${locus} = $(($start + 2))-${fin}\n"
done | sed -e 's/$/\\3/' > analyses/L1648/alignments/concat/na/ng_na_Cpart