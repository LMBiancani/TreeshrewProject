#!/bin/bash
#SBATCH --job-name="IQout"
#SBATCH --time=96:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH -c 1
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --output=/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/slurm_outs/step_5_outs/IQarr_%A_%a_trshrw.out


cd $SLURM_SUBMIT_DIR
date
gtree_outs_path="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/step_4_gtree_out_files/"

array_list_path="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_treeshrew/array_list.txt"

path_to_fileline="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_treeshrew/"

> gtrees.txt; cat ${array_list_path} | while read line1; do cat ${path_to_fileline}${line1} >> gtrees.txt; done
> gtrees.tre; cat gtrees.txt | while read line; do cat ${gtree_outs_path}inference_${line}.treefile >> gtrees.tre; done
date
