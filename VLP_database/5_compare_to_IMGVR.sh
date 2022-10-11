#!/bin/bash

source ~/anaconda3/etc/profile.d/conda.sh
conda activate vep

samp='/home/lv71395/mwielsch/binfl/virome/new22/public_VIROME_DB/IMG_VR/chunks'
nd=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )
##
filenames='/binfl/virome/new22/phageDB/phageDB_filenames'
ref='/binfl/virome/new22/public_VIROME_DB/IMG_VR/'
input='/binfl/virome/new22/phageDB/for_MASH/'
out='/binfl/virome/new22/phageDB/mash_screen/'
while read line; do

tag=${line%_length_*}
echo " this is $line  with tag $tag"
mash screen -w -p 10 ${ref}IMG_VR${nd}.msh ${input}${line} > ${out}AD_vs_IMG_VR${nd}_${tag}.tab
sed -i "s/$/\t${line}/" ${out}AD_vs_IMG_VR${nd}_${tag}.tab  ## add column with query name

done<${filenames}
