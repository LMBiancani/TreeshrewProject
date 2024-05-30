#!/bin/sh

#SBATCH --job-name="filter"
#SBATCH --time=24:00:00  # walltime limit (HH:MM:SS)
#SBATCH --mail-user="biancani@uri.edu" #CHANGE user email address
#SBATCH --mail-type=ALL
### adjust/add sbatch flags as needed

cd $SLURM_SUBMIT_DIR

module purge

#for URI's Andromeda cluster
module load Biopython/1.78-foss-2020b

## Update the following paths as needed...

## path to TreeshrewProject Directory:
PROJECT=/data/schwartzlab/Biancani/TreeshrewProject

## path to output folder (will be created if doesn't exist):
OUTFOLDER=$PROJECT/output/FilteredByTaxa

## path to Taxon List (csv file containing taxon to group correspondence list):
TAXA=$PROJECT/TaxonList.txt

## path to SISRS_Run directory (contains SISRS output from step 00):
SISRS_Run=$PROJECT/SISRS_run

## Specify the following parameters...

## Sequence Completeness Threshold (e.g. 0.33 indicates each passing sequence must have over 33% non N)
COMPLETENESS=0.33

## Number of Taxa Retained (e.g. 25 means the locus passes if 25 taxa are remaining)
TAXA_PRESENT=25

## Number of Groups Present (e.g. for the treeshrew project all 6 groups must be present)
GROUPS_PRESENT=6

mkdir -p $OUTFOLDER
python $PROJECT/01_filterByTaxa/filter_SISRS_output.py $TAXA $SISRS_Run/aligned_contigs $OUTFOLDER $COMPLETENESS $TAXA_PRESENT $GROUPS_PRESENT

