#!/usr/bin/env bash
#SBATCH --job-name=04_2_generate_clade_classification_file.sh
#SBATCH --output=../out/04_2_generate_clade_classification_file.out
#SBATCH --error=../err/04_2_generate_clade_classification_file.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course/EDTA_annotation
CONTAINER_DIR=/data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif

cd $WORK_DIR

apptainer exec -C -H /data -H ${pwd}:/work \
--writable-tmpfs -u $CONTAINER_DIR \
TEsorter assembly.fasta.mod.EDTA.raw/LTR/assembly.fasta.mod.LTR.intact.fa -db rexdb-plant

