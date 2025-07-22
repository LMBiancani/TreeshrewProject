#!/bin/bash
#SBATCH --job-name="IQprep"
#SBATCH --time=1:00:00  # walltime limit (HH:MM:SS)
#SBATCH --mail-user="biancani@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -c 1
#SBATCH --mem-per-cpu=6G

script_work_dir="/data/schwartzlab/Biancani/output_SISRS/mammals/iqtree/"
scripts_dir="/data/schwartzlab/Biancani/TreeschrewProject/iqtree/"
aligned_loci_path="/data/schwartzlab/Biancani/output_SISRS/mammals/SISRS_Run/aligned_loci/"
array_work_folder="iqtree_assessment"
cd ${script_work_dir}
mkdir ${array_work_folder}
cd ${array_work_folder}
mkdir scf
ls ${aligned_loci_path} | rev | cut -f1 -d/ | rev | split -l 4000 - aligned_loci_list_
arrayN=$(ls aligned_loci_list_* | wc -l)
ls aligned_loci_list_* > array_list.txt
echo sbatch --array=1-${arrayN}%40 ${scripts_dir}iqtree_array.sh
