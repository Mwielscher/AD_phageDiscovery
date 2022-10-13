#!/bin/bash

samp='/binfl/virome/new22/published/study_IDs_after_SPADES.txt'
name=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )
in='/binfl/virome/new22/published/contigs/'
out='/binfl/virome/new22/published/PHAGE_contigs/'


mkdir ${out}${name}
source ~/anaconda3/etc/profile.d/conda.sh
conda activate vs2

virsorter run -w ${out}${name} -i ${in}${name}_Spades_contigs.fasta --min-length 1500 -j 4 all
