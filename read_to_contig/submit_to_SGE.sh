#!/bin/bash
#SBATCH -J load2
#SBATCH -N 1
#SBATCH -p vsc3plus_0064    
#SBATCH --qos=vsc3plus_0064    
#SBATCH --tasks-per-node=20
#SBATCH --array=567-1066

echo "starting task id $SLURM_ARRAY_TASK_ID"

##-----------------------------          do in 500 batch to prevent home directory from filling up

#there are 1066 jobs

./run_sra_download.sh $SLURM_ARRAY_TASK_ID
