#!/bin/bash
#SBATCH --job-name="screen"
#SBATCH --time=24:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --cpus-per-task=1
#SBATCH -p uri-cpu
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user="biancani@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL

## UPDATE as needed...
# path to Project Directory:
PROJECT=/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject
# path to iqtree array work folder:
array_work_folder=$PROJECT/output/iqtree_assessment
# path to collected, trimmed, constraint trees:
constraint_trees=$array_work_folder/GeneTreesConstrained/constraint_trees.tre
# path to collected constrained gene trees file:
genetree_path=$array_work_folder/GeneTreesConstrained/gtrees.tre
# path to collected gene tree names:
genetree_names=$array_work_folder/GeneTreesConstrained/gtrees.txt
# path to R script:
script_path=/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/03_screening/treescreen.R
# path to output folder:
output=$PROJECT/output/

# export local space for R packages:
export R_LIBS=~/R-packages

cd $output
module load r/4.4.0

date
mkdir -p screening_assessments
cd screening_assessments
Rscript ${script_path} ${constraint_trees} ${genetree_path} ${genetree_names}
date
