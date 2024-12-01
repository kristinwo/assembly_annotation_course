#!/usr/bin/env bash
#SBATCH --job-name=04_8_runparse_RM.sh
#SBATCH --output=../out/04_8_runparse_RM.out
#SBATCH --error=../err/04_8_runparse_RM.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course/EDTA_annotation
GENOME=$WORK_DIR/assembly.fasta.mod.EDTA.anno/assembly.fasta.mod.out

cd $WORK_DIR

module add BioPerl/1.7.8-GCCcore-10.3.0
perl ../scripts/parseRM.pl -i $GENOME -l 50,1 -v