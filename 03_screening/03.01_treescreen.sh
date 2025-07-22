#!/bin/bash
#SBATCH --job-name="screen"
#SBATCH --time=24:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -c 1
#SBATCH --mail-user="biancani@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --mem-per-cpu=6G

## UPDATE as needed...
# path to Project Directory:
PROJECT=/data/schwartzlab/Biancani/TreeshrewProject
# path to iqtree array work folder:
array_work_folder=$PROJECT/output/iqtree_assessment
# path to collected, trimmed, constraint trees:
constraint_trees=$array_work_folder/GeneTreesConstrained/constraint_trees.tre
# path to collected constrained gene trees file:
genetree_path=$array_work_folder/GeneTreesConstrained/gtrees.tre
# path to collected gene tree names:
genetree_names=$array_work_folder/GeneTreesConstrained/gtrees.txt
# path to R script:
script_path=/data/schwartzlab/Biancani/TreeshrewProject/03_screening/treescreen.R
# path to output folder:
output=$PROJECT/output/

cd $output
module load R/4.0.3-foss-2020b

date
mkdir -p screening_assessments
cd screening_assessments
Rscript ${script_path} ${constraint_trees} ${genetree_path} ${genetree_names}
date

