#!/bin/bash
in='/binfl/virome/new22/published/trimmed_host_removed/'
in2='/binfl/virome/new22/phage_read_mapping/counts/'
samp='/binfl/virome/new22/published/study_IDs_after_SPADES.txt'
nd=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )
bin='/home/bowtie2-2.4.1-linux-x86_64/'
sam='/home/samtools-1.9/'

ref="/binfl/virome/new22/phage_read_mapping/REF/phage.ref"

mkdir ${in2}${nd}

${bin}./bowtie2 --very-sensitive -x ${ref} -1 ${in}${nd}_ready_R1.fastq.gz \
 -2 ${in}${nd}_ready_R2.fastq.gz  |\
 ${sam}./samtools view -bS -o ${in2}${nd}/${nd}.bam

${sam}./samtools sort ${in2}${nd}/${nd}.bam -o ${in2}${nd}/${nd}_sorted.bam
${sam}./samtools index ${in2}${nd}/${nd}_sorted.bam

source ~/anaconda3/etc/profile.d/conda.sh
conda activate vep

# https://bitbucket.org/berkeleylab/metabat/wiki/Home
jgi_summarize_bam_contig_depths --outputDepth ${in2}${nd}/${nd}_depth.txt ${in2}${nd}/${nd}_sorted.bam
