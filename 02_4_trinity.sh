#!/usr/bin/env bash
#SBATCH --job-name=02_4_trinity
#SBATCH --output=../out/02_4_trinity.out
#SBATCH --error=../err/02_4_trinity.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course
RNA_LEFT=$WORK_DIR/fastp/fastp_RNASeq1.fastq.gz
RNA_RIGTH=$WORK_DIR/fastp/fastp_RNASeq2.fastq.gz
OUT_DIR=$WORK_DIR/assemblies/trinity

# Load trinity module
module load Trinity/2.15.1-foss-2021a

# Use trinity for transriptome assembly
Trinity --seqType fq --left $RNA_LEFT --right $RNA_RIGTH --CPU 16 --max_memory 64G