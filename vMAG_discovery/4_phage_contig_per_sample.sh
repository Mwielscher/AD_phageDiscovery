#!/bin/bash

out='/binfl/virome/new22/published/PHAGE_contigs/CLEANED_PHAGE_CONTIGS/'
samp='/binfl/virome/new22/published/study_IDs_after_SPADES.txt'
nd=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )
in='/mwielsch/binfl/virome/new22/published/PHAGE_contigs/'
fasta='/mwielsch/binfl/virome/new22/published/contigs/'


awk '{print $1}' ${in}${nd}/final-viral-score.tsv > ${out}vir_sorter_${nd} 
sed -i 's/||.*//g' ${out}vir_sorter_${nd}   ## remove stuff after ||
sed -i '1d' ${out}vir_sorter_${nd}        ### remove header line

awk '$4 > 0.95 {print $1}' ${in}${nd}_Spades_contigs.fasta_gt150bp_dvfpred.txt > ${out}vir_finder_${nd}  ## subset to minimum scoer and extract column 1
awk '$4 > 0.95 {print $0}' ${in}${nd}_Spades_contigs.fasta_gt150bp_dvfpred.txt > ${out}vir_finder_${nd}_summary  ## subset to minimum score
sed -i '1d' ${out}vir_finder_${nd}
sed -i '1d' ${out}vir_finder_${nd}_summary

## combine
cat ${out}vir_finder_${nd} ${out}vir_sorter_${nd} >> ${out}vir_combined_${nd}
sort ${out}vir_combined_${nd} | uniq -u > ${out}vir_combined_no_dupl_${nd}   ## remove duplicates
#### make a file based on dvfpred
grep -i -E -f ${out}vir_sorter_${nd} ${in}${nd}_Spades_contigs.fasta_gt150bp_dvfpred.txt > ${in}${nd}testing
paste ${in}${nd}testing ${out}vir_sorter_${nd} > ${in}${nd}testing_2

## combine list per sample
cat ${in}${nd}testing_2 ${out}vir_finder_${nd}_summary >> ${out}${nd}final_phage_contig_overview

###  create the PHAGE FASTA file
#https://github.com/lh3/seqtk
source ~/anaconda3/etc/profile.d/conda.sh
conda activate vep
seqtk subseq ${fasta}${nd}_Spades_contigs.fasta ${out}vir_combined_no_dupl_${nd} > ${out}${nd}phage_genomes.fasta

## --- reheader
sed -i "s/NODE_/${nd}_NODE_/" ${out}${nd}phage_genomes.fasta



#rm ${out}vir_combined_no_dupl_${nd} 
rm ${out}vir_finder_${nd}
rm ${out}vir_sorter_${nd}
rm ${out}vir_combined_${nd}
rm ${in}${nd}testing
rm ${in}${nd}testing_2
