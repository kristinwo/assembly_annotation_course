#!/usr/bin/env bash
#SBATCH --job-name=06_4_run_genespace.sh
#SBATCH --output=../out/06_4_run_genespace.out
#SBATCH --error=../err/06_4_run_genespace.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8


WORKDIR="/data/users/kolsen/assembly_annotation_course"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

apptainer exec \
    --bind $COURSEDIR  \
    --bind $WORKDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/genespace_latest.sif Rscript $WORKDIR/scripts/06_5_genespace.R $WORKDIR/annotation_evaluation/genespace
