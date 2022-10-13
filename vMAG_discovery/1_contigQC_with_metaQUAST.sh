#!/bin/bash
#SBATCH -J quast-pub
#SBATCH -N 1
#SBATCH -p vsc3plus_0064    
#SBATCH --qos=vsc3plus_0064    
#SBATCH --tasks-per-node=20


bin2='/home/quast-master/'
outdir='/binfl/virome/new22/published/contigs/'
quastref='/binfl/virome/new22/meduni/quast_ref'

ls -d ${outdir}*Spades_contigs.fasta > ${outdir}all_files 

quast_in=$(<${outdir}all_files)

mkdir ${outdir}QUAST_ALL

echo "$quast_in"
##  ------------------------------------------  QC contigs with QUAST
# http://quast.sourceforge.net/docs/manual.html 
cd ${bin2}

python metaquast.py ${quast_in} --references-list ${quastref} --k-mer-stats -o ${outdir}QUAST_ALL 
