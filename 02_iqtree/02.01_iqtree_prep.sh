q#!/bin/bash
#SBATCH --job-name="IQprep"
#SBATCH --time=1:00:00  # walltime limit (HH:MM:SS)
#SBATCH --mail-user="biancani@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -c 1
#SBATCH --mem-per-cpu=6G

## UPDATE PATHS as needed...
# path to TreeshrewProject Directory:
PROJECT=/data/schwartzlab/Biancani/TreeshrewProject
# path to IQtree scripts:
scripts_dir=$PROJECT/02_iqtree
# path to aligned, filtered loci:
aligned_loci_path=$PROJECT/output/FilteredByTaxa
# path to project output folder (will be created if doesn't exist):
OUTPUT=$PROJECT/output
# name of iqtree array work folder (will be created if doesn't exist):
array_work_folder=iqtree_assessment


mkdir -p $OUTPUT
cd $OUTPUT
mkdir -p ${array_work_folder}
cd ${array_work_folder}
mkdir scf
ls ${aligned_loci_path} | rev | cut -f1 -d/ | rev | split - aligned_loci_list_
arrayN=$(ls aligned_loci_list_* | wc -l)
ls aligned_loci_list_* > array_list.txt
echo sbatch --array=1-${arrayN}%40 ${scripts_dir}iqtree_array.sh
