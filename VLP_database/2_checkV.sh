#!/bin/bash
#BATCH -J checkV
#SBATCH -N 1
#SBATCH -p binf --qos normal_binf
#SBATCH -C binf --nodelist binf-14
#SBATCH --tasks-per-node=20

dir='/binfl/virome/new22/phageDB/'
bin='/home/bowtie2-2.4.1-linux-x86_64/'

mkdir ${dir}checkV
mkdir ${dir}bowtie_ref


checkv end_to_end ${dir}initial_PHAGE_DB.fasta ${dir}checkV\
 -d /home/lv71395/mwielsch/binfl/checkV_db/checkv-db-v1.0 -t 16
 
${bin}./bowtie2-build ${dir}ALL_PHAGE_GENOMES.fasta ${dir}bowtie_ref/PhageDB.contigs
