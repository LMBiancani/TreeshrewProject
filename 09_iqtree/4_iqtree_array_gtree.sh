#!/bin/bash
#SBATCH --job-name="IQarr"
#SBATCH --time=48:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH -c 1
#SBATCH --mem-per-cpu=6G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --output=/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/slurm_outs/step_4_outs/IQarr_%A_%a_treeshrew.out
#SBATCH --array=6001-6452%200 #6452 


cd $SLURM_SUBMIT_DIR

date

fileline=$(sed -n ${SLURM_ARRAY_TASK_ID}p /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_treeshrew/array_list.txt)
path_to_fileline="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_treeshrew/"
aligned_loci_path="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs"
iqtree_exe="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/IQ_TREE2/iqtree-2.4.0-Linux-intel/bin/iqtree2"
out_files="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/step_4_gtree_out_files/"

cat ${path_to_fileline}${fileline} | while read line
do
	echo $line
	${iqtree_exe} -nt 1 -s ${aligned_loci_path}/${line} -pre ${out_files}inference_${line} -alrt 1000 -m GTR+G
	rm ${out_files}inference_${line}.ckp.gz ${out_files}inference_${line}.iqtree ${out_files}inference_${line}.log ${out_files}inference_${line}.bionj ${out_files}inference_${line}.mldist ${out_files}inference_${line}.uniqueseq.phy
done
