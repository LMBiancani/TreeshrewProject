#!/bin/bash
#SBATCH --job-name="IQout"
#SBATCH --time=96:00:00  # walltime limit (HH:MM:SS)
#SBATCH --mail-user="biancani@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -c 1
#SBATCH --mem-per-cpu=8G

cd $SLURM_SUBMIT_DIR

date
assessment_folder="/data/schwartzlab/Biancani/output_SISRS/mammals/iqtree/iqtree_assessment"
output_prefix="iqtree_assessment"
cat ${assessment_folder}/LnLs_*.csv > ${output_prefix}_dLnLs.csv

date
> ${output_prefix}_scf.csv
cat ${assessment_folder}/array_list.txt | while read array_list_line
do
	cat ${assessment_folder}/${array_list_line} | while read aligned_loci_list_line
	do
		fscf="${assessment_folder}/scf/scf_${aligned_loci_list_line}"
		echo $fscf","$(sed -n 2p $fscf | cut -f2 -d,)","$(sed -n 3p $fscf | cut -f2 -d,)","$(sed -n 4p $fscf | cut -f2 -d,) >> ${output_prefix}_scf.csv
	done
done
date
sed -i -e "s+${assessment_folder}/scf/scf_++g" ${output_prefix}_scf.csv
date
