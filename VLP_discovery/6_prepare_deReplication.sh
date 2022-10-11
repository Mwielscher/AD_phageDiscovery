#!/bin/bash

in='/binfl/virome/new22/published/PHAGE_contigs/CLEANED_PHAGE_CONTIGS/'
samp='/mwielsch/binfl/virome/new22/published/study_IDs_after_SPADES.txt'
nd=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )
work='/binfl/virome/new22/phageDB/prepDREP/'

cp ${in}${nd}phage_genomes.fasta ${work}${nd}phage_genomes.fasta

splitfasta ${work}${nd}phage_genomes.fasta

rm ${work}${nd}phage_genomes.fasta 
