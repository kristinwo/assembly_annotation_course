#!/usr/bin/env bash
#SBATCH --job-name=02_2_hifiasm
#SBATCH --output=../out/02_2_hifiasm.out
#SBATCH --error=../err/02_2_hifiasm.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course
FILE_DIR=$WORK_DIR/N13/ERR11437334.fastq.gz
OUT_DIR=$WORK_DIR/assemblies/hifiasm

# Use hifiasm for assembly
apptainer exec \
--bind $WORK_DIR \
/containers/apptainer/hifiasm_0.19.8.sif \
hifiasm -o $OUT_DIR/N13.asm -t 32 $FILE_DIR
