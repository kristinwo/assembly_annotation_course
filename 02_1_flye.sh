#!/usr/bin/env bash
#SBATCH --job-name=02_1_flye
#SBATCH --output=../out/02_1_flye.out
#SBATCH --error=../err/02_1_flye.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course
FILE_DIR=$WORK_DIR/N13/ERR11437334.fastq.gz
OUT_DIR=$WORK_DIR/assemblies/flye/

# Use flye for assembly
apptainer exec \
--bind $WORK_DIR \
/containers/apptainer/flye_2.9.5.sif \
flye --pacbio-hifi $FILE_DIR --out-dir $OUT_DIR