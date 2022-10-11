#!/bin/bash

out='/binfl/virome/download/'
samp='/binfl/virome/download/IDs_for_download.txt'
name=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )

cd ~
export PATH=$PATH:$PWD/sratoolkit.2.11.0-ubuntu64/bin
prefetch ${name} && fastq-dump ${name} --skip-technical --split-3 --gzip --outdir ${out}
