#!/bin/bash
#SBATCH --job-name="iqout"
#SBATCH --time=700:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH -c 1
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --output=/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/slurm_outs/step_7_outs/iqout_trsrw_primates.out

cd $SLURM_SUBMIT_DIR

arrayLen=6452 #number of lines in the array_list.txt)
assessment_folder="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/step3_concat_primates_out_files"


> combined_iqtree_dLnLs_concat_primates.csv
date
for f in $(seq 1 ${arrayLen})
do
	cat ${assessment_folder}/partitions_${f}.txt | while read l
	do
		locname=$(echo ${l} | cut -f2 -d" " | cut -f2- -d_)
		range1=$(echo ${l} | cut -f4 -d" ")
		tree1=$(sed -n 2p ${assessment_folder}/calcLnL_${f}.sitelh | awk -v a="${range1}" 'BEGIN {split(a, A, /-/)} {x=0;for(i=A[1]+1;i<=A[2]+1;i++)x=x+$i;print x}')
		tree2=$(sed -n 3p ${assessment_folder}/calcLnL_${f}.sitelh | awk -v a="${range1}" 'BEGIN {split(a, A, /-/)} {x=0;for(i=A[1]+1;i<=A[2]+1;i++)x=x+$i;print x}')
		tree3=$(sed -n 4p ${assessment_folder}/calcLnL_${f}.sitelh | awk -v a="${range1}" 'BEGIN {split(a, A, /-/)} {x=0;for(i=A[1]+1;i<=A[2]+1;i++)x=x+$i;print x}')
		echo ${locname},${tree1},${tree2},${tree3} >> combined_iqtree_dLnLs_concat_primates.csv
	done
done
date
