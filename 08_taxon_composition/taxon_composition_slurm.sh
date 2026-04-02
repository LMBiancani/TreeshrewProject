#!/bin/bash
#SBATCH --job-name="taxastat"
#SBATCH --time=700:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --cpus-per-task=1
#SBATCH -p uri-cpu
#SBATCH --mem-per-cpu=6G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL




cd $SLURM_SUBMIT_DIR
alignments_folder="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs/"
taxon_table="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/cactus_mammal_alignment/taxalist.csv"

# Number of files already processed (exclude header line)
already_processed=3371965 #this is how many files were processed in the first job submission (time limit 700 hours)
count=0

#no need to execut this the second time because we already have this file
#cut -f1 -d, ${taxon_table} | uniq -c | awk '{print $2}' > allsp.txt

# Only write the header if taxon_composition.csv does NOT exist
if [[ ! -f taxon_composition.csv ]]; then

	echo "Alignment_name,"$(cut -f1 -d, ${taxon_table} | uniq -c | awk '{print $2}' | paste -sd",") > taxon_composition.csv
fi

for f in ${alignments_folder}/*.fasta
do
	count=$((count+1))

	# Skip files already processed
    	if [[ $count -le $already_processed ]]; then
            continue
    	fi

	echo $(basename ${f})","$(grep ">" ${f} | sed -e 's/>//g' | grep -f - ${taxon_table} | cut -f1 -d, | sort - allsp.txt | uniq -c | awk '{$1 = $1 - 1; print $1}' | paste -sd",") >> taxon_composition.csv
done
