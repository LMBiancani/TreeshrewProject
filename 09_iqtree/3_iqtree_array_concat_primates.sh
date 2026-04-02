#!/bin/bash
#SBATCH --job-name="IQarr"
#SBATCH --time=48:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH -c 10
#SBATCH --mem-per-cpu=6G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --output=/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/slurm_outs/step_3_outs/IQarr_%A_%a_prmt.out
#SBATCH --array=6001-6452%200 #6452

cd $SLURM_SUBMIT_DIR

date
module load uri/main R/4.2.0-foss-2021b
module load uri/main Python/3.7.4-GCCcore-8.3.0

#NOTE: all the outputs from this step were moved to /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/step3_concat_primates_out_files/

fileline=$(sed -n ${SLURM_ARRAY_TASK_ID}p /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_primates/array_list.txt)

path_to_fileline="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_primates/"

aligned_loci_path="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs"

iqtree_exe="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/IQ_TREE2/iqtree-2.4.0-Linux-intel/bin/iqtree2"

trees_to_eval="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/select-files_focal_tips/primates_trees_to_fit.tre"

scripts_dir="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/"


infiles=$(cat ${path_to_fileline}${fileline} | while read line; do echo ${aligned_loci_path}/${line}; done | paste -sd" ")

python3 /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/AMAS/amas/AMAS.py concat -f fasta -d dna --out-format fasta --part-format raxml -i $infiles -t concatenated_${SLURM_ARRAY_TASK_ID}.fasta -p partitions_${SLURM_ARRAY_TASK_ID}.txt

Rscript ${scripts_dir}trimTrees.R concatenated_${SLURM_ARRAY_TASK_ID}.fasta ${trees_to_eval} ./trees_${SLURM_ARRAY_TASK_ID}.tre

${iqtree_exe} -nt 10 -s concatenated_${SLURM_ARRAY_TASK_ID}.fasta -spp partitions_${SLURM_ARRAY_TASK_ID}.txt -z ./trees_${SLURM_ARRAY_TASK_ID}.tre -pre calcLnL_${SLURM_ARRAY_TASK_ID} -n 0 -m GTR+G -wsl
${iqtree_exe} -nt 10 -s concatenated_${SLURM_ARRAY_TASK_ID}.fasta -spp partitions_${SLURM_ARRAY_TASK_ID}.txt -pre inference_${SLURM_ARRAY_TASK_ID} -m GTR+G -bb 1000 -alrt 1000 -wsr

date
