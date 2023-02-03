#!/bin/bash

# AMAS on Path
export PATH=/hpc/group/bio1/carlos/apps/AMAS/amas:${PATH}
# Path to single gene alignments
aln_dir=$"analyses/ngmin/alignments/single"
# initiate partition file using AMAS hack
for locus in $(cat misc_files/L1082.txt) ; do
	AMAS.py concat -i ${aln_dir}/${locus}_selected_55_ngmin.fna -f fasta -d dna \
	-p ${aln_dir}/${locus}_selected_55_ngmin_part --part-format raxml
# modify AMAS file to get codon parition file
	grep -e "DNA" ${aln_dir}/${locus}_selected_55_ngmin_part | sed 's/p1/p2/' | sed 's/1-/2-/' >> \
	${aln_dir}/${locus}_selected_55_ngmin_part 
	grep -e "DNA" ${aln_dir}/${locus}_selected_55_ngmin_part | sed -n 1p | sed 's/p1/p3/' | \
	sed 's/1-/3-/' >> ${aln_dir}/${locus}_selected_55_ngmin_part
	cat ${aln_dir}/${locus}_selected_55_ngmin_part | sed -e 's/$/\\3/' > ${aln_dir}/${locus}_selected_55_ngmin_Cpart
done
# remove intermediate partition files
rm ${aln_dir}/*_part
rm concatenated.out