#!/bin/sh
#SBATCH --job-name="filter"
#SBATCH --time=36:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node - just use 1 
#SBATCH --mail-user="biancani@uri.edu" #CHANGE user email address
#SBATCH --mail-type=ALL

## UPDATE PATHS ...
# path to TreeshrewProject Directory:
PROJECT=/data/schwartzlab/Biancani/TreeshrewProject
# path to output folder (will be created if doesn't exist):
OUTFOLDER=$PROJECT/output/FilteredByTaxa
# path to SISRS_Run directory (contains SISRS output from step 00):
SISRS_Run=$PROJECT/SISRS_Run
# path to Groups List (csv file containing taxon to group correspondence list):
TAXONGROUPS=$PROJECT/01_filterByTaxa/groups.csv

## SPECIFY PARAMETERS ...
SEQCOMPLETE=0.33 # Minimum Sequence Completeness (e.g. 0.33 is at least 33% non N)
MINTAXA=25 # Minimum Number of Taxa Retained (e.g. locus passes if 25 taxa are remaining)
MINGROUPS=6 # Minimum Number of Groups Present (e.g. all 6 groups must be present)

cd $SLURM_SUBMIT_DIR

module purge
#for URI's Andromeda cluster
module load Biopython/1.78-foss-2020b

mkdir -p $OUTFOLDER
python $PROJECT/01_filterByTaxa/filter_SISRS_output.py $TAXONGROUPS $SISRS_Run/aligned_contigs $OUTFOLDER $SEQCOMPLETE $MINTAXA $MINGROUPS

