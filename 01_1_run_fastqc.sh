#!/usr/bin/env bash
#SBATCH --job-name=01_1_run_fastqc
#SBATCH --output=../out/01_1_run_fastqc.out
#SBATCH --error=../err/01_1_run_fastqc.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/kolsen/assembly_annotation_course
FASTQC_DIR=$WORKDIR/fastqc
FILE_DIR=$WORKDIR/RNAseq_Sha/ERR754081_2.fastq.gz #change file for N13, ERR754081_1 and ERR754081_2

# Run fastqc on the specified file
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastqc-0.12.1.sif \
fastqc -o $FASTQC_DIR $FILE_DIR
