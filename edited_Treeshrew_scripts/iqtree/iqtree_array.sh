#!/bin/bash
#SBATCH --job-name="IQarr"
#SBATCH --time=192:00:00  # walltime limit (HH:MM:SS)
#SBATCH --mail-user="biancani@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -c 1
#SBATCH --mem-per-cpu=6G


cd $SLURM_SUBMIT_DIR

date
module load R/4.0.3-foss-2020b

fileline=$(sed -n ${SLURM_ARRAY_TASK_ID}p array_list.txt)
aligned_loci_path="/data/schwartzlab/Biancani/output_SISRS/mammals/SISRS_Run/aligned_loci/"
#location of iqtree executable:
iqtree_exe="/data/schwartzlab/alex/andromeda_tools/iqtree-2.1.2-Linux/bin/iqtree2"
#path to iqtree scripts
scripts_dir="/data/schwartzlab/Biancani/TreeschrewProject/iqtree/"
#path to alternative trees file
trees_to_eval="/data/schwartzlab/Biancani/output_SISRS/mammals/iqtree/Placental_Hypotheses.tre"
focal_tips1="/data/schwartzlab/Biancani/output_SISRS/mammals/iqtree/tips_Boreoeutheria.txt"
focal_tips2="/data/schwartzlab/Biancani/output_SISRS/mammals/iqtree/tips_Boreoeutheria.txt"
focal_tips3="/data/schwartzlab/Biancani/output_SISRS/mammals/iqtree/tips_Afrotheria.txt"
outgroup_tips="/data/schwartzlab/Biancani/output_SISRS/mammals/iqtree/tips_Outgroup.txt"

> LnLs_${SLURM_ARRAY_TASK_ID}.csv
cat ${fileline} | while read line
do
	echo $line
	Rscript ${scripts_dir}trimTrees.R ${aligned_loci_path}/${line} ${trees_to_eval} ./trees_${line}.tre
	${iqtree_exe} -nt 1 -s ${aligned_loci_path}/${line} -z ./trees_${line}.tre -pre calcLnL_${line} -n 0 -m GTR+G
	echo $line","$(grep "Tree 1 / LogL:" calcLnL_${line}.log | cut -f2 -d: )","$(grep "Tree 2 / LogL:" calcLnL_${line}.log | cut -f2 -d: )","$(grep "Tree 3 / LogL:" calcLnL_${line}.log | cut -f2 -d: ) >> LnLs_${SLURM_ARRAY_TASK_ID}.csv
	
	sed -n 1p ./trees_${line}.tre > ./tree1_${line}.tre
	${iqtree_exe} -nt 1 -t ./tree1_${line}.tre -s ${aligned_loci_path}/${line} --scf 500 --prefix concord1_${line}
	rm ./tree1_${line}.tre
	echo "ID,sCF,sCF_N,sDF1,sDF1_N,sDF2,sDF2_N,sN,debug" > scf/scf_${line}
	Rscript ${scripts_dir}getSCF.R concord1_${line}.cf.branch concord1_${line}.cf.stat ${focal_tips1} ${outgroup_tips} >> scf/scf_${line}
	rm concord1_${line}.log concord1_${line}.cf.branch concord1_${line}.cf.stat concord1_${line}.cf.tree concord1_${line}.cf.tree.nex
	
	sed -n 2p ./trees_${line}.tre > ./tree2_${line}.tre
	${iqtree_exe} -nt 1 -t ./tree2_${line}.tre -s ${aligned_loci_path}/${line} --scf 500 --prefix concord2_${line}
	rm ./tree2_${line}.tre
	Rscript ${scripts_dir}getSCF.R concord2_${line}.cf.branch concord2_${line}.cf.stat ${focal_tips2} ${outgroup_tips} >> scf/scf_${line}
	rm concord2_${line}.log concord2_${line}.cf.branch concord2_${line}.cf.stat concord2_${line}.cf.tree concord2_${line}.cf.tree.nex

	sed -n 3p ./trees_${line}.tre > ./tree3_${line}.tre
	${iqtree_exe} -nt 1 -t ./tree3_${line}.tre -s ${aligned_loci_path}/${line} --scf 500 --prefix concord3_${line}
	rm ./tree3_${line}.tre
	Rscript ${scripts_dir}getSCF.R concord3_${line}.cf.branch concord3_${line}.cf.stat ${focal_tips3} ${outgroup_tips} >> scf/scf_${line}
	rm concord3_${line}.log concord3_${line}.cf.branch concord3_${line}.cf.stat concord3_${line}.cf.tree concord3_${line}.cf.tree.nex
	
	rm ./trees_${line}.tre calcLnL_${line}.ckp.gz calcLnL_${line}.iqtree calcLnL_${line}.log calcLnL_${line}.treefile calcLnL_${line}.trees
	rm calcLnL_${line}.uniqueseq.phy
done
