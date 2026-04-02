#!/bin/bash
#SBATCH --job-name="4_annotate"
#SBATCH --time=100:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --cpus-per-task=1
#SBATCH -p uri-cpu
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user="yana_hrytsenko@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL

cd $SLURM_SUBMIT_DIR
date
scripts_dir="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/04_annotation/"
sisrsContigs="/scratch/workspace/biancani_uri_edu-treeshrew/TreeshrewProject/SISRS_Run/aligned_contigs/"
taxonName="Homo_sapiens"
assemblyDB="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/Homo_sapiens/GCF_000001405.39_GRCh38.p13_genomic.fna" 
assemblyGFF="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/Homo_sapiens/GCF_000001405.39_GRCh38.p13_genomic.gff"
outpath="/scratch3/workspace/yana_hrytsenko_uri_edu-shared/Projects/TreeshrewProject/output/04_annotation/"
outputMode="l"


module purge
module load uri/main Biopython/1.79-foss-2021b 

python ${scripts_dir}/annotation_getTaxContigs.py ${taxonName} ${sisrsContigs}


module purge
module load uri/main BLAST+/2.12.0-gompi-2021b


makeblastdb -in ${assemblyDB} -dbtype nucl

blastn -query ${taxonName}.fasta -db ${assemblyDB} -outfmt 6 -num_threads 20 > ${outpath}blast_results.blast

python3 ${scripts_dir}/annotation_blast_parser.py ${outpath}blast_results.blast > ${outpath}full_table.bed

sort -k1,1 -k2,2n ${outpath}full_table.bed > ${outpath}full_table_sorted.bed


module purge
module load uri/main bedtools2/2.31.1 


bedtools intersect -a ${outpath}full_table_sorted.bed -b ${assemblyGFF} -wa -wb > ${outpath}full_table_annotated.bed

python3 ${scripts_dir}/annotation_bed2table.py ${outpath}full_table_annotated.bed ${outputMode} > ${outpath}annotations.csv

date
