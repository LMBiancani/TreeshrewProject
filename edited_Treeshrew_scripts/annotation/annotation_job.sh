#!/bin/bash
#SBATCH --job-name="annotate"
#SBATCH --time=100:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=20   # processor core(s) per node
#SBATCH --mail-user="biancani@uri.edu" ### CHANGE THIS to your user email address

cd $SLURM_SUBMIT_DIR
date
### location of annotation scripts:
scripts_dir="/data/schwartzlab/Biancani/TreeschrewProject/annotation/"
### path to aligned loci:
sisrsContigs="/data/schwartzlab/Biancani/output_SISRS/mammals/SISRS_Run/aligned_loci/"
### taxon name closest to reference
taxonName="Pan_troglodytes"
### location of Homo_sapiens reference:
assemblyDB="/data/schwartzlab/alex/tree_shew_analysis/NCBI_genomes/Homo_sapiens/GCF_000001405.39_GRCh38.p13_genomic.mod.fna"
assemblyGFF="/data/schwartzlab/alex/tree_shew_analysis/NCBI_genomes/Homo_sapiens/GCF_000001405.39_GRCh38.p13_genomic.gff"
outputMode="l"

#Andromeda (URI's cluster) specific
module purge
module load Biopython/1.78-foss-2020b
#
python ${scripts_dir}/annotation_getTaxContigs.py ${taxonName} ${sisrsContigs}

#Andromeda (URI's cluster) specific
module purge
module load BLAST+
#

### commented out because Blast DB already created for this reference
#makeblastdb -in ${assemblyDB} -dbtype nucl

blastn -query ${taxonName}.fasta -db ${assemblyDB} -outfmt 6 -num_threads 20 > blast_results.blast

python3 ${scripts_dir}/annotation_blast_parser.py blast_results.blast > full_table.bed

sort -k1,1 -k2,2n full_table.bed > full_table_sorted.bed

#Andromeda (URI's cluster) specific
module purge
module load BEDTools/2.27.1-foss-2018b
#

bedtools intersect -a full_table_sorted.bed -b ${assemblyGFF} -wa -wb > full_table_annotated.bed

python3 ${scripts_dir}/annotation_bed2table.py full_table_annotated.bed ${outputMode} > annotations.csv

date
