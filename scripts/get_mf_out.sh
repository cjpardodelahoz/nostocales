#!/bin/bash

# This is a script to extract the results of the modelfinder analysis from iqtree
# log files. Run in the command line as:
# get_mf_out loci_codes log_file_dir log_suffix output_dir out_suffix
#
# loci_codes 	path to file with list of loci code or prefix.
# log_file_dir 	directory with the iqtree log files. No "/" at the end.
# log_suffix 	suffix of the log files that come after the locus code. No "_" at the beginning
# output_dir	output directory. No "/" at the end.
# out_suffix	Output suffix to write on output file after loci code.

for locus in $(< ${1}) ; do
	while IFS= read -r line; do 
		grep -e "${line}" ${2}/${locus}_${3} 
	done < misc_files/shet_mf_log_query.txt | sed 's/.*Criterion:.*//' | \
	sort | uniq | awk 'NF' > ${4}/${locus}_${5}.mf
done