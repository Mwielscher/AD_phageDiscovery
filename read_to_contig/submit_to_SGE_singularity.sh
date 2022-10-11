#!/bin/bash
#SBATCH -J fastQC
#SBATCH -N 1
#SBATCH -p vsc3plus_0064    
#SBATCH --qos=vsc3plus_0064    
#SBATCH --tasks-per-node=20
#SBATCH --array=3-1066


module load go/1.11 singularity/3.4.1

singularity exec -B /home/lv71395/mwielsch/binfl/virome/new22/published/ fastqc.img /bin/bash /home/lv71395/mwielsch/binfl/virome/new22/published/run_fastQC.sh $SLURM_ARRAY_TASK_ID

