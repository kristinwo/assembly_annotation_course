#!/usr/bin/env bash
#SBATCH --job-name=01_2_run_fastp
#SBATCH --output=../out/01_2_run_fastp.out
#SBATCH --error=../err/01_2_run_fastp.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/kolsen/assembly_annotation_course
FASTP_DIR=$WORKDIR/fastp
FILE_DIR_1=$WORKDIR/RNAseq_Sha/ERR754081_1.fastq.gz
FILE_DIR_2=$WORKDIR/RNAseq_Sha/ERR754081_2.fastq.gz

# Run fastp on the specified file
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif \
fastp -i $FILE_DIR_1 -I $FILE_DIR_2 -o $FASTP_DIR/fastp_RNASeq1.fastq.gz -O $FASTP_DIR/fastp_RNASeq2.fastq.gz
