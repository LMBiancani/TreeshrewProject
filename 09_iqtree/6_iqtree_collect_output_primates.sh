#!/bin/bash
#SBATCH --job-name="IQout"
#SBATCH --time=48:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH -c 1
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --output=/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/slurm_outs/step_6_outs/IQout_prmt.out

cd $SLURM_SUBMIT_DIR

date
assessment_folder="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_primates/"

output_prefix="combined_iqtree_primates"

#this LnLs_outs folder is for primates
cat /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/LnLs_outs/LnLs_*.csv > ${output_prefix}_dLnLs.csv

date
> ${output_prefix}_scf.csv
cat ${assessment_folder}array_list.txt | while read array_list_line
do
	cat ${assessment_folder}${array_list_line} | while read aligned_loci_list_line
	do
		fscf="${assessment_folder}/scf/scf_${aligned_loci_list_line}"
		echo $fscf","$(sed -n 2p $fscf | cut -f2 -d,)","$(sed -n 3p $fscf | cut -f2 -d,)","$(sed -n 4p $fscf | cut -f2 -d,) >> ${output_prefix}_scf.csv
	done
done
date
sed -i -e "s+${assessment_folder}/scf/scf_++g" ${output_prefix}_scf.csv
date
