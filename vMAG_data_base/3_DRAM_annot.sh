#!/bin/bash
#BATCH -J dram
#SBATCH -N 1
#SBATCH -p binf --qos normal_binf
#SBATCH -C binf --nodelist binf-14
#SBATCH --tasks-per-node=20

in='/binfl/virome/new22/phageDB/'

source ~/anaconda3/etc/profile.d/conda.sh
conda activate DRAM_2


DRAM-v.py annotate -i ${in}initial_PHAGE_DB.fasta -o ${in}DRAM/ad_db \
 --min_contig_size 1500 --threads 16
