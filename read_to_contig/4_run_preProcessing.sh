#!/bin/bash

ref='/home/bowtie_ref/GRCh38_noalt_as/GRCh38_noalt_as'
sam='/home/samtools-1.9/'
trim='/home/Trimmomatic-0.39/'
bin='/home/bowtie2-2.4.1-linux-x86_64/'
in='/binfl/virome/new22/published/download/'
out='/binfl/virome/new22/published/trimmed_host_removed/'
adapter='/home/Trimmomatic-0.39/adapters/TruSeq3-PE.fa'
samp='/binfl/virome/new22/published/IDs_for_download.txt'
nd=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )
in2='/binfl/virome/new22/published/download/read_NB_added/'
qc="/binfl/virome/new22/published/count_qc/"

### add forward and rev number for reads

zcat ${in}${nd}_1.fastq.gz |sed 's/length.*$//g' | sed 's/ //g'| sed 's/\+SRR.*/\+/g' > ${in2}inter_${nd}_1.fastq
zcat ${in}${nd}_2.fastq.gz |sed 's/length.*$//g' | sed 's/ //g'| sed 's/\+SRR.*/\+/g' > ${in2}inter_${nd}_2.fastq
awk '{ if ($1 ~ /^@SRR/) print $0"/1"; else print $0}' ${in2}inter_${nd}_1.fastq > ${in2}${nd}_1_ok.fastq
awk '{ if ($1 ~ /^@SRR/) print $0"/2"; else print $0}' ${in2}inter_${nd}_2.fastq > ${in2}${nd}_2_ok.fastq

rm ${in2}inter_${nd}_1.fastq
rm ${in2}inter_${nd}_2.fastq

### count input reads -- that should be the same as the fastQC result
grep "@SRR" ${in2}${nd}_2_ok.fastq | wc -l > ${qc}${nd}_all_R1_reads

## --------------------------              trim reads
java -jar ${trim}trimmomatic-0.39.jar PE ${in2}${nd}_1_ok.fastq ${in2}${nd}_2_ok.fastq ${out}${nd}_forward_paired.fq.gz ${out}${nd}_forward_unpaired.fq.gz\
 ${out}${nd}_reverse_paired.fq.gz ${out}${nd}_reverse_unpaired.fq.gz\
 ILLUMINACLIP:${adapter}:2:30:10: SLIDINGWINDOW:4:20 MINLEN:50 -threads 20

## --------------------------  count not aligned reads as well as number of reads after trimming !!
zgrep "@SRR" ${out}${nd}_forward_unpaired.fq.gz | wc -l > ${qc}${nd}_forward_not_paired
zgrep "@SRR" ${out}${nd}_reverse_unpaired.fq.gz | wc -l > ${qc}${nd}_reverse_not_paired
zgrep "@SRR" ${out}${nd}_forward_paired.fq.gz | wc -l > ${qc}${nd}_forward_paired

rm ${out}${nd}_forward_unpaired.fq.gz
rm ${out}${nd}_reverse_unpaired.fq.gz

### ------------------   map reads against human reference sequence
${bin}./bowtie2 -p 16 -x ${ref} -1 ${out}${nd}_forward_paired.fq.gz -2 ${out}${nd}_reverse_paired.fq.gz \
 -S ${out}${nd}mapped_plus_unmapped.sam --very-sensitive --dovetail

rm ${out}${nd}_forward_paired.fq.gz
rm ${out}${nd}_reverse_paired.fq.gz

${sam}./samtools view -bS ${out}${nd}mapped_plus_unmapped.sam > ${out}${nd}mapped_plus_unmapped.bam
rm ${out}${nd}mapped_plus_unmapped.sam 

## filter  ---------   keep only not aligned reads
${sam}./samtools view -b -f 12 -F 256 ${out}${nd}mapped_plus_unmapped.bam > ${out}${nd}_bothReadsUnmapped.bam
rm ${out}${nd}mapped_plus_unmapped.bam

${sam}./samtools sort -n  ${out}${nd}_bothReadsUnmapped.bam -o ${out}${nd}_bothReadsUnmapped_sorted.bam
rm ${out}${nd}_bothReadsUnmapped.bam

## -----------------  producce input fastq files for any further analysis
${sam}./samtools fastq -@ 16 ${out}${nd}_bothReadsUnmapped_sorted.bam \
    -1 ${out}${nd}_host_removed_R1.fastq.gz \
    -2 ${out}${nd}_host_removed_R2.fastq.gz \
    -0 /dev/null -s /dev/null -n

rm ${out}${nd}_bothReadsUnmapped_sorted.bam
