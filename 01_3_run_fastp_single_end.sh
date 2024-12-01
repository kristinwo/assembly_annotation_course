#!/usr/bin/env bash
#SBATCH --job-name=01_3_run_fastp_single_end
#SBATCH --output=../out/01_3_run_fastp_single_end.out
#SBATCH --error=../err/01_3_run_fastp_single_end.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/kolsen/assembly_annotation_course
FASTP_DIR=$WORKDIR/fastp
FILE_DIR=$WORKDIR/N13/ERR11437334.fastq.gz


# Run fastp on the specified file without filtering
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif \
fastp -i $FILE_DIR -o $FASTP_DIR/fastp_N13.fastq.gz -A -G -Q -L