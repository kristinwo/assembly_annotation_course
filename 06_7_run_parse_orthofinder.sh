#!/usr/bin/env bash
#SBATCH --job-name=06_7_run_parse_orthofinder.sh
#SBATCH --output=../out/06_7_run_parse_orthofinder.out
#SBATCH --error=../err/06_7_run_parse_orthofinder.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/kolsen/assembly_annotation_course/annotation_evaluation/genespace

# Load the R module
module load R/4.3.2-foss-2021a

# Set a custom library path
LIB_PATH="/scratch/kolsen/R/library"
mkdir -p $LIB_PATH  # Create the directory if it doesn't exist

# Install required packages in the specified library
Rscript -e 'install.packages("tidyverse", lib = "'$LIB_PATH'")'
Rscript -e 'install.packages("data.table", lib = "'$LIB_PATH'")'
Rscript -e 'install.packages("cowplot", lib = "'$LIB_PATH'")'
Rscript -e 'install.packages("UpSetR", lib = "'$LIB_PATH'")'
Rscript -e 'if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager", lib = "'$LIB_PATH'"); BiocManager::install("ComplexUpset", lib = "'$LIB_PATH'")'

# Change to the working directory
cd $WORKDIR

# Run the main R script, specifying the library path
Rscript -e '.libPaths(c("'$LIB_PATH'", .libPaths())); source("/data/users/kolsen/assembly_annotation_course/scripts/06_6_parse_orthofinder.R")'
