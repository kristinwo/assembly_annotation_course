#!/usr/bin/env bash
#SBATCH --job-name=04_4_create_fai_file.sh
#SBATCH --output=../out/04_4_create_fai_file.out
#SBATCH --error=../err/04_4_create_fai_file.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

WORK_DIR="/data/users/kolsen/assembly_annotation_course/EDTA_annotation"
cd $WORK_DIR

module load SAMtools/1.13-GCC-10.3.0

samtools faidx assembly.fasta