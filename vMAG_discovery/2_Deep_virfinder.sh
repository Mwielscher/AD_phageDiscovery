samp='/binfl/virome/new22/published/study_IDs_after_SPADES.txt'
name=$(awk -v var="$SLURM_ARRAY_TASK_ID" 'FNR==var {print $1}' ${samp} )
in='/binfl/virome/new22/published/contigs/'
out='/binfl/virome/new22/published/PHAGE_contigs/'


cd /home/lv71395/mwielsch/DeepVirFinder
python dvf.py -i ${in}${name}_Spades_contigs.fasta \
 -o ${out} \
 -l 150 \
 -c 12
