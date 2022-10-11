#!/bin/bash
#BATCH -J mashGut
#SBATCH -N 1
#SBATCH -p vsc3plus_0064    
#SBATCH --qos=vsc3plus_0064    
#SBATCH --tasks-per-node=20

source ~/anaconda3/etc/profile.d/conda.sh
conda activate vep

filenames='/binfl/virome/new22/phageDB/phageDB_filenames.txt'
ref='/binfl/virome/new22/public_VIROME_DB/GutPhageDb/'
input='/binfl/virome/new22/phageDB/for_MASH/'
out='/binfl/virome/new22/phageDB/mash_screen/'
while read line; do

tag=${line%_length_*}
echo " this is $line  with tag $tag"
mash screen -w -p 10 ${ref}Gut_phageDB.msh ${input}${line} > ${out}AD_vs_GutDB_${tag}.tab
sed -i "s/$/\t${line}/" ${out}AD_vs_GutDB_${tag}.tab  ## add column with query name

done<${filenames}
