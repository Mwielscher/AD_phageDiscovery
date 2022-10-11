#!/bin/sh
#SBATCH -J VirS
#SBATCH -N 1
#SBATCH -p vsc3plus_0064    
#SBATCH --qos=vsc3plus_0064    
#SBATCH --tasks-per-node=20
#SBATCH --array=3-265


echo "starting task id $SLURM_ARRAY_TASK_ID"

./2_Deep_virfinder.sh  $SLURM_ARRAY_TASK_ID
