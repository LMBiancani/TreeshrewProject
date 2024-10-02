#!/bin/bash
#SBATCH --job-name="IQout"
#SBATCH --time=24:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -c 1
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user="biancani@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL

## UPDATE as needed...
# path to Project Directory:
PROJECT=/data/schwartzlab/Biancani/TreeshrewProject
# path to iqtree array work folder:
array_work_folder=$PROJECT/output/iqtree_assessment
# path to gene trees working folder:
work_folder=$array_work_folder/GeneTreesConstrained
# path to individual gene trees:
GeneTrees=$array_work_folder/GeneTreesConstrained/Individual_Constrained_GeneTrees
# path to individual trimmed constraint trees:
ConTrees=$array_work_folder/GeneTreesConstrained/TrimmedConstraintTrees

cd $work_folder
date
> gtrees.txt; cat $array_work_folder/array_list.txt | while read line1; do cat $array_work_folder/${line1} >> gtrees.txt; done
> gtrees.tre; cat gtrees.txt | while read line; do cat $GeneTrees/inference_${line}.treefile >> gtrees.tre; done
> constraint_trees.tre; cat gtrees.txt | while read line; do cat $ConTrees/inference_${line}.constraint.tre >> constraint_trees.tre; done
date

