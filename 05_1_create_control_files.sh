#!/usr/bin/env bash
#SBATCH --job-name=05_1_create_control_files.sh
#SBATCH --output=../out/05_1_create_control_files.out
#SBATCH --error=../err/05_1_create_control_files.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=5-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR="/data/users/kolsen/assembly_annotation_course/MAKER"
mkdir -p $WORK_DIR
cd $WORK_DIR

apptainer exec --bind /data \
/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif maker -CTL
