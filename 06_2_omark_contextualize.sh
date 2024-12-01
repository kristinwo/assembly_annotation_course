#!/usr/bin/env bash
#SBATCH --job-name=06_2_omark_contextualize.sh
#SBATCH --output=../out/06_2_omark_contextualize.out
#SBATCH --error=../err/06_2_omark_contextualize.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kolsen/assembly_annotation_course/OMArk"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"

mkdir -p $WORKDIR
cd $WORKDIR

# Download the missing and fragmented Hierarchical Orthologous groups (HOGs)
python $COURSEDIR/softwares/OMArk-0.3.0/utils/omark_contextualize.py fragment -m $WORKDIR/assembly.all.maker.proteins.renamed.filtered.fasta.omamer -o $WORKDIR/omark_output -f fragment_HOGs
python $COURSEDIR/softwares/OMArk-0.3.0/utils/omark_contextualize.py missing -m $WORKDIR/assembly.all.maker.proteins.renamed.filtered.fasta.omamer -o $WORKDIR/omark_output -f missing_HOGs 