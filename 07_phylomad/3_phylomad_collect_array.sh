#!/bin/bash
#SBATCH --job-name="PMout"
#SBATCH --time=100:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --cpus-per-task=1
#SBATCH -p uri-cpu
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL
#SBATCH --array=[1-1000] 

date
base_path="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/SISRS/post_processing/"

# Remove any old combined files from previous runs
rm -f ${base_path}phylomad_assessment/combined_phylomad_*.csv

skip_log="skipped_folders.log"

array_list_line=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${base_path}phylomad_assessment/array_list.txt)

> ${base_path}phylomad_assessment/combined_phylomad_${array_list_line}.csv
cat ${base_path}phylomad_assessment/${array_list_line} | while read aligned_loci_list_line
do
	f=${base_path}"phylomad_assessment/"${aligned_loci_list_line}".phylomad.subst"
	
	# Skip if folder does not exist
	if [ ! -d "$f" ]; then
    	    echo "Skipping ${f} (folder not found)" >> ${skip_log}
    	    continue
	fi
	
	loc=$(head -1 ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val1=$(grep "chisq.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val2=$(grep "multlik.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val3=$(grep "biochemdiv.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val4=$(grep "consind.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val5=$(grep "delta.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val6=$(grep -w "brsup.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val7=$(grep "CIbrsup.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val8=$(grep "trlen.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	val9=$(grep "maha.stdev.from.pred.dist" ${f}/output.pvals.PhyloMAd.csv | cut -f2 -d,)
	echo ${loc},${val1},${val2},${val3},${val4},${val5},${val6},${val7},${val8},${val9} >> ${base_path}phylomad_assessment/combined_phylomad_${array_list_line}.csv
done
