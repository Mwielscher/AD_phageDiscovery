#!/bin/bash
#BATCH -J deREP
#SBATCH -N 1
#SBATCH -p binf --qos normal_binf
#SBATCH -C binf --nodelist binf-14
#SBATCH --tasks-per-node=20

dir='/binfl/virome/new22/phageDB/prepDREP/'
out='/binfl/virome/new22/phageDB/'

mkdir ${out}/DeREPLI

dRep dereplicate ${out}/DeREPLI -g ${dir}*.fasta\
 --S_algorithm ANImf -nc .5 -l 10000 -p 20\
 -N50W 0 -sizeW 1 --ignoreGenomeQuality --clusterAlg single
