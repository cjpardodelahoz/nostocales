#!/bin/bash

# This is a script ot create the clade_def file that includes all bipartitions in a
# reference tree. 
# Requires bp. Install as follows:
# Download and install go
# https://go.dev/doc/install
# Create a go module (which will create the go.mod file)
# cd ~/gophy
# go mod init gophy
# Clone the github repo
# git clone https://github.com/FePhyFoFum/gophy.git
# Install the missing compiler library
# brew install nlopt
# Install bp and add it to path
# go build gophy/bp/bp.go

# Run in shell as:
# ./get_clade_def.sh path/to/input/tree out/dir


# Use bp to get edges
bp -t ${1} -e > ${2}/edges
# Create file with the bipartitions
grep -e "(" ${2}/edges | awk -F'[ ]' '{print $3}' | awk -F'[)]' \
'{print $1}' | awk '{gsub("\\(\\(", ""); print}' > ${2}/biparts.temp
for line in $(cat ${2}/biparts.temp) ; do 
	sorted=$(echo ${line} | tr , "\n" | sort | tr "\n" ,)
	printf "\"${sorted}\n" | rev | cut -c2- | rev
done | awk '{gsub("\\,", "\"\"\+\"\""); print}' | sort| uniq > ${2}/biparts
# Generate the clade-def file for disco vista from the biparts file
touch ${2}/clade_def
printf "Clade Name\tClade Definition\tSection Letter\tComponents\tShow\tComments\n" > \
	${2}/clade_def
clade=1
for bipart in $(< ${2}/biparts) ; do
	printf "${clade}\t${bipart}\"\"\"\tNone\t\t1\t\n" >> \
	${2}/clade_def
	let "clade++"
done
# Add the "All" line to the clade definition file. Will do this by hand for now. Need to
# figure out a way to do it automatically.
printf "All\t\"Anabaena_sp_4_3\"\"+\"\"Anabaena_cylindrica_PCC_7122\"\"+\"\"Anabaena_sp_90\"\"+\"\"Anabaena_sp_WA113\"\"+\"\"Anabaenopsis_circularis_NIES_21\"\"+\"\"Aphanizomenon_flos_aquae_NIES_81\"\"+\"\"Calothrix_desertica_PCC_7102_v2\"\"+\"\"Calothrix_elsteri_CCALA_953\"\"+\"\"Calothrix_rhizosoleniae_SC01\"\"+\"\"Calothrix_sp_336_3\"\"+\"\"Calothrix_sp_NIES_2098\"\"+\"\"Calothrix_sp_NIES_2100\"\"+\"\"Calothrix_sp_NIES_3974\"\"+\"\"Calothrix_sp_NIES_4105\"\"+\"\"Calothrix_sp_PCC_6303\"\"+\"\"Chlorogloeopsis_fritschii_PCC_9212\"\"+\"\"Chroococcidiopsis_thermalis_PCC_7203\"\"+\"\"Cuspidothrix_issatschenkoi_CHARLIE_1\"\"+\"\"Cylindrospermopsis_raciborskii_CS_505_v2\"\"+\"\"Cylindrospermum_stagnale_PCC_7417\"\"+\"\"Dictyo3444.bin.3\"\"+\"\"Dolichospermum_planctonicum_strain_NIES_80\"\"+\"\"Fischerella_sp_NIES_4106\"\"+\"\"Fischerella_sp_PCC_9605\"\"+\"\"Fischerella_thermalis_WC114\"\"+\"\"Fortiea_contorta_PCC_7126\"\"+\"\"Gloeocapsa_sp_PCC_7428\"\"+\"\"JL23bin6\"\"+\"\"Mastigocladopsis_repens_PCC_10914\"\"+\"\"Nodularia_sp_NIES_3585\"\"+\"\"Nodularia_spumigena_CENA596\"\"+\"\"Nodularia_spumigena_UHCC_0039\"\"+\"\"Nostoc_azollae_0708\"\"+\"\"Nostoc_calcicola_FACHB_389\"\"+\"\"Nostoc_linckia_NIES_25\"\"+\"\"Nostoc_sp_106C\"\"+\"\"Nostoc_sp_B_2019\"\"+\"\"Nostoc_sp_CENA543\"\"+\"\"Nostoc_sp_JC1668\"\"+\"\"Nostoc_sp_NIES_2111\"\"+\"\"Nostoc_sp_NIES_4103\"\"+\"\"Nostoc_sp_PCC_7524\"\"+\"\"Nostoc_sp_T09\"\"+\"\"Nostocales_cyanobacterium_HT_58_2\"\"+\"\"Peltula.bin.10\"\"+\"\"Richelia_intracellularis_HH01\"\"+\"\"Rivularia_sp_PCC_7116\"\"+\"\"Scytonema_sp_HK_05_v2\"\"+\"\"Sphaerospermopsis_kisseleviana_NIES_73\"\"+\"\"Synechocystis_sp_PCC_7509\"\"+\"\"Tolypothrix_bouteillei_VB521301\"\"+\"\"Tolypothrix_sp_NIES_4075\"\"+\"\"Tolypothrix_tenuis_PCC_7101\"\"+\"\"Trichormus_variabilis_ATCC_29413\"\"+\"\"Trichormus_variabilis_PCC_6309\"\"\"\tNone\t\t1\t" >> \
${2}/clade_def