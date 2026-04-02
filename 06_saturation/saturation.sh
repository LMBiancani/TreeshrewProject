#!/bin/bash
#SBATCH --job-name="6_saturation"
#SBATCH --time=100:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --cpus-per-task=1
#SBATCH -p uri-cpu
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL

aligned_loci_path="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs" 
script_path="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/06_saturation/saturation.R"
cd $SLURM_SUBMIT_DIR
module load uri/main R/4.2.0-foss-2021b
date
mkdir /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/output/06_saturation/saturation_assessments
Rscript ${script_path} ${aligned_loci_path}
mv saturation_output.csv /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/output/06_saturation/saturation_assessments/
date
