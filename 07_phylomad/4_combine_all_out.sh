#!/bin/bash
#SBATCH --job-name="CombOuts"
#SBATCH --time=30:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --cpus-per-task=1
#SBATCH -p uri-cpu
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL


> /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/phylomad_assessment/combined_all_phylo_outs/combined_all.csv      # clear output file
> missing_files_step_4.log    # clear log file

while read suffix; do
    file="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/phylomad_assessment/combined_phylomad_${suffix}.csv"

    if [ -f "$file" ]; then
        cat "$file" >> /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/phylomad_assessment/combined_all_phylo_outs/combined_all.csv
    else
        echo "Skipping missing file: $file" >> missing_files_step_4.log
    fi

done < /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/07_phylomad/debugging/array_list.txt

