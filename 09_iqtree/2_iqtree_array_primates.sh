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
#SBATCH --output=/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/slurm_outs/step_2_outs/IQarr_%A_%a.out
#SBATCH --array=6001-6452%200 #6452 
cd $SLURM_SUBMIT_DIR

date
module load uri/main R/4.2.0-foss-2021b

fileline=$(sed -n ${SLURM_ARRAY_TASK_ID}p /scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_primates/array_list.txt)

aligned_loci_path="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs"

iqtree_exe="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/IQ_TREE2/iqtree-2.4.0-Linux-intel/bin/iqtree2"

scripts_dir="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/"


scf_out_primates="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/iqtree_assessment_primates/"

LnLS_outs_primates="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/LnLs_outs/"

#Note: Focal tips are used to identify the node of interest in the trees to evaluate. For each hypothesis, you determine which 2 out of three are sister groups and select one of those two sister groups to locate the node in the tree to evaluate (which is one node deeper than the focal tips)

#The trees for the three hypotheses that we are evaluating.
trees_to_eval="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/select-files_focal_tips/primates_trees_to_fit.tre"

#Focal tips for hypothesis Tree 1: One group of primates.
focal_tips1="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/select-files_focal_tips/focal_tips_primates.txt"

#Focal tips for hypothesis Tree 2: Second group of primates.
focal_tips2="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/select-files_focal_tips/focal_tips_primates2.txt"

#Focal tips for hypothesis Tree 3: These are all remaining species once you know primates and outgroup, so this tells you if one or the other group of primates goes elsewhere.
focal_tips3="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/select-files_focal_tips/focal_tips_primates.txt"

#Tips in the outgroup (not primates).
outgroup_tips="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/09_iqtree/select-files_focal_tips/outgroup_tips.txt"

> ${LnLS_outs_primates}LnLs_${SLURM_ARRAY_TASK_ID}.csv
cat ${scf_out_primates}${fileline} | while read line
do
	echo $line
	Rscript ${scripts_dir}trimTrees.R ${aligned_loci_path}/${line} ${trees_to_eval} ./trees_${line}.tre
	${iqtree_exe} -nt 1 -s ${aligned_loci_path}/${line} -z ./trees_${line}.tre -pre calcLnL_${line} -n 0 -m GTR+G
	echo $line","$(grep "Tree 1 / LogL:" calcLnL_${line}.log | cut -f2 -d: )","$(grep "Tree 2 / LogL:" calcLnL_${line}.log | cut -f2 -d: )","$(grep "Tree 3 / LogL:" calcLnL_${line}.log | cut -f2 -d: ) >> ${LnLS_outs_primates}LnLs_${SLURM_ARRAY_TASK_ID}.csv
	
	sed -n 1p ./trees_${line}.tre > ./tree1_${line}.tre
	${iqtree_exe} -nt 1 -t ./tree1_${line}.tre -s ${aligned_loci_path}/${line} --scf 500 --prefix concord1_${line}
	rm ./tree1_${line}.tre
	echo "ID,sCF,sCF_N,sDF1,sDF1_N,sDF2,sDF2_N,sN,debug" > ${scf_out_primates}scf/scf_${line}
	Rscript ${scripts_dir}getSCF.R concord1_${line}.cf.branch concord1_${line}.cf.stat ${focal_tips1} ${outgroup_tips} >> ${scf_out_primates}scf/scf_${line}
	rm concord1_${line}.log concord1_${line}.cf.branch concord1_${line}.cf.stat concord1_${line}.cf.tree concord1_${line}.cf.tree.nex
	
	sed -n 2p ./trees_${line}.tre > ./tree2_${line}.tre
	${iqtree_exe} -nt 1 -t ./tree2_${line}.tre -s ${aligned_loci_path}/${line} --scf 500 --prefix concord2_${line}
	rm ./tree2_${line}.tre
	Rscript ${scripts_dir}getSCF.R concord2_${line}.cf.branch concord2_${line}.cf.stat ${focal_tips2} ${outgroup_tips} >> ${scf_out_primates}scf/scf_${line}
	rm concord2_${line}.log concord2_${line}.cf.branch concord2_${line}.cf.stat concord2_${line}.cf.tree concord2_${line}.cf.tree.nex

	sed -n 3p ./trees_${line}.tre > ./tree3_${line}.tre
	${iqtree_exe} -nt 1 -t ./tree3_${line}.tre -s ${aligned_loci_path}/${line} --scf 500 --prefix concord3_${line}
	rm ./tree3_${line}.tre
	Rscript ${scripts_dir}getSCF.R concord3_${line}.cf.branch concord3_${line}.cf.stat ${focal_tips3} ${outgroup_tips} >> ${scf_out_primates}scf/scf_${line}
	rm concord3_${line}.log concord3_${line}.cf.branch concord3_${line}.cf.stat concord3_${line}.cf.tree concord3_${line}.cf.tree.nex
	
	rm ./trees_${line}.tre calcLnL_${line}.ckp.gz calcLnL_${line}.iqtree calcLnL_${line}.log calcLnL_${line}.treefile calcLnL_${line}.trees
	rm calcLnL_${line}.uniqueseq.phy
	
	#break #remove after, only for testing purposes
done
