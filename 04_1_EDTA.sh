#!/usr/bin/env bash
#SBATCH --job-name=04_1_EDTA.sh
#SBATCH --output=../out/04_1_EDTA.out
#SBATCH --error=../err/04_1_EDTA.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course
FLYE_ASSEMBLY=$WORK_DIR/assemblies/flye/assembly.fasta
CONTAINER_DIR=/data/courses/assembly-annotation-course/containers2/EDTA_v1.9.6.sif
OUT_DIR=$WORK_DIR/EDTA_annotation

mkdir -p $OUT_DIR
cd $OUT_DIR

# Run EDTA
apptainer exec -C -H /data -H ${pwd}:/work \
--writable-tmpfs -u $CONTAINER_DIR \
EDTA.pl --genome $FLYE_ASSEMBLY --species others --step all --cds "/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated" --anno 1 --threads 20

