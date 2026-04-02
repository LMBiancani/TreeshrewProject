#!/bin/bash
#SBATCH --job-name="IQprep"
#SBATCH --time=1:00:00  # walltime limit (HH:MM:SS)
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH -c 1
#SBATCH --mem-per-cpu=6G
#SBATCH --output=/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/slurm_outs/IQprep_A%_treeshrew.out



script_work_dir="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/"
scripts_dir="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/"
aligned_loci_path="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs/"
array_work_folder="iqtree_assessment_treeshrew" #_primates
cd ${script_work_dir}
mkdir ${array_work_folder}
cd ${array_work_folder}
mkdir scf
ls ${aligned_loci_path} | rev | cut -f1 -d/ | rev | split - aligned_loci_list_
arrayN=$(ls aligned_loci_list_* | wc -l)
ls aligned_loci_list_* > array_list.txt
echo sbatch --array=1-${arrayN}%200 ${scripts_dir}2_iqtree_array.sh
