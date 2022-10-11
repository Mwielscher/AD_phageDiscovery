#!/bin/bash
out='/binfl/virome/published/fastqc/'
in='/binfl/virome/published/download/'
samp='/binfl/virome/published/IDs_for_download.txt'
name=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )

fastqc ${in}${name}_1.fastq.gz --outdir ${out}
