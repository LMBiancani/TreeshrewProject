#!/bin/bash
#SBATCH --job-name="PMarr"
#SBATCH --time=100:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --cpus-per-task=1
#SBATCH -p uri-cpu
#SBATCH --mem-per-cpu=10G
#SBATCH --output="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/07_phylomad/slurm_outs/PMarr_%A_%a.out"
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL 
#SBATCH --array=1432,1434 
module purge
module load uri/main R/4.2.0-foss-2021b

date

job_id=$SLURM_ARRAY_TASK_ID

fileline=$(sed -n ${job_id}p /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/phylomad_assessment/array_list.txt)
aligned_loci_path="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs/"
base_phylomad_script="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/PhyloMAd/phylomad/codeFolder/commandLineFile.Rscript"

cat "/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/phylomad_assessment/"${fileline} | while read line
do
	echo $line #locus file
	sed -e 's+input$dataPath <- c(".*")+input$dataPath <- c("'"$aligned_loci_path""$line"'")+g' ${base_phylomad_script} | sed -e 's/alNames <- c(".*")/alNames <- c("'"$line"'")/g' | sed -e 's+input$outputFolder <- ".*"+input$outputFolder <- "/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/phylomad_assessment/"+g' > script_${job_id}.R
	Rscript script_${job_id}.R
	rm script_${job_id}.R
done
