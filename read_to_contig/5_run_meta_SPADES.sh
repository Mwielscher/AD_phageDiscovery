#!/bin/bash


seq='/binfl/virome/new22/published/sequences_for_SPADES.txt'
samp='/binfl/virome/new22/published/study_ids_for_SPADES.txt'
id=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var{print $1}' ${samp})
in='/binfl/virome/new22/published/trimmed_host_removed/'
qc='/binfl/virome/new22/published/count_qc/'
bin='/home/SPAdes-3.15.2-Linux/bin/'
out='/binfl/virome/new22/published/contigs/'

grep "${id}" ${seq} | awk '{ print $1}' > ${in}test_${id}

##  ----- use @ instead of / second sed to get the file path in there
##sed 's/$/_host_removed_R1.fastq.gz/' test_${id} |sed "s@SRR@${in}SRR@g" | tr '\n' ' '  > fwd_${id}
##sed 's/$/_host_removed_R2.fastq.gz/' test_${id} |sed "s@SRR@${in}SRR@g" | tr '\n' ' ' > rev_${id}

arg1=$(sed 's/$/_host_removed_R1.fastq.gz/' ${in}test_${id} |sed "s@SRR@${in}SRR@g" | tr '\n' ' ')
arg2=$(sed 's/$/_host_removed_R2.fastq.gz/' ${in}test_${id} |sed "s@SRR@${in}SRR@g" | tr '\n' ' ')
rm ${in}test_${id}

zcat ${arg1} >> ${in}${id}_ready_R1.fastq
gzip ${in}${id}_ready_R1.fastq
zcat ${arg2} >> ${in}${id}_ready_R2.fastq
gzip ${in}${id}_ready_R2.fastq

mkdir ${out}${id}

${bin}spades.py --meta --pe1-1 ${in}${id}_ready_R1.fastq.gz --pe1-2 ${in}${id}_ready_R2.fastq.gz\
 -o ${out}${id}

source ~/anaconda3/etc/profile.d/conda.sh
conda activate vep

cat ${out}${id}/scaffolds.fasta | faswc  > ${qc}${id}_all_contigs
cat ${out}${id}/scaffolds.fasta |faslen  | fasfilter -t length 2000.. > ${out}${id}_Spades_contigs.fasta
cat ${out}${id}_Spades_contigs.fasta | faswc  > ${qc}${id}_final_contigs

#rm -r ${out}${id}




