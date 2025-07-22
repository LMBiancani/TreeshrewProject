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
PROJECT=/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject
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
# Generate a list of contigs:
> contigs.txt; cat $array_work_folder/array_list.txt | while read line1; do cat $array_work_folder/${line1} >> contigs.txt; done
# Copy contig list to gtrees.txt which will be edited (to remove entries for missing gene trees) to produce a list of gene tree names
cp contigs.txt gtrees.txt
# Iterate through list of contigs, if corresponding gene tree exists, append it to gtrees.tre, if it does not exist, remove the name from gtrees.txt
> gtrees.tre; cat contigs.txt | while read line; do [ -f $GeneTrees/inference_${line}.treefile ] && cat $GeneTrees/inference_${line}.treefile >> gtrees.tre || sed -i "/^${line}$/d" gtrees.txt; done
# Iterate through the (now edited) list of gene trees and append the corresponding constraint tree to constraint_trees.tre
> constraint_trees.tre; cat gtrees.txt | while read line; do cat $ConTrees/inference_${line}.constraint.tre >> constraint_trees.tre; done
date

