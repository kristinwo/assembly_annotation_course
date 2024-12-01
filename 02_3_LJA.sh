#!/usr/bin/env bash
#SBATCH --job-name=02_3_LJA
#SBATCH --output=../out/02_3_LJA.out
#SBATCH --error=../err/02_3_LJA.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course
FILE_DIR=$WORK_DIR/N13/ERR11437334.fastq.gz
OUT_DIR=$WORK_DIR/assemblies/LJA

# Use LJA for assembly
apptainer exec \
--bind $WORK_DIR \
/containers/apptainer/lja-0.2.sif \
lja --diploid -o $OUT_DIR --reads $FILE_DIR