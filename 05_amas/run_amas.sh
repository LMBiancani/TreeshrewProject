#!/bin/bash
#SBATCH --job-name="5_amas"
#SBATCH --time=100:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=12   # processor core(s) per node
#SBATCH --cpus-per-task=1
#SBATCH -p uri-cpu
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL

module purge
module load uri/main Python/3.7.4-GCCcore-8.3.0
path_to_amas="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/AMAS/amas/AMAS.py" 
folder_with_loci="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs/"
cores_to_use=12

cd $SLURM_SUBMIT_DIR
date

mkdir /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/output/05_amas/amas_assessments

python /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/05_amas/run_amas.py ${folder_with_loci} ${cores_to_use} ${path_to_amas}

mv amas_total_results.txt /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/output/05_amas/amas_assessments/
rm amas_output_temp.txt

date
