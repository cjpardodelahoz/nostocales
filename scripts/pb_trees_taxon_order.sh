#!/bin/bash

# Script to add tree at the top of the list with tip labels so all nexus files
# have taxa in the same order when we convert them to nexus. 
# This mimicks how mrbayes outputs trees in nexus and it is how bucky likes it
for trees in analyses/phylonetworks/alignments/*treelist ; do
 sed -i '1s/^/(Anabaena_cylindrica_PCC_7122,Chroococcidiopsis_thermalis_PCC_7203,Cylindrospermum_stagnale_PCC_7417,Fischerella_sp_PCC_9605,Fortiea_contorta_PCC_7126,JL23bin6,Nodularia_sp_NIES_3585,Peltula.bin.10,Rivularia_sp_PCC_7116,Scytonema_sp_HK_05_v2,Tolypothrix_sp_NIES_4075,Trichormus_variabilis_ATCC_29413);\n/' ${trees}
done