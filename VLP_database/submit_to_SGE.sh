#!/bin/sh
#SBATCH -J mash
#SBATCH -N 1
#SBATCH -p vsc3plus_0256    
#SBATCH --qos=vsc3plus_0256    
#SBATCH --tasks-per-node=20
#SBATCH --array=1-5

echo "starting task id $SLURM_ARRAY_TASK_ID"

./4_compare_to_Gut_phageDB.sh $SLURM_ARRAY_TASK_ID
