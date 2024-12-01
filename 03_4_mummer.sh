#!/usr/bin/env bash
#SBATCH --job-name=03_4_mummer.sh
#SBATCH --output=../out/03_4_mummer.out
#SBATCH --error=../err/03_4_mummer.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course
FLYE_ASSEMBLY=$WORK_DIR/assemblies/flye/assembly.fasta
HIFIASM_ASSEMBLY=$WORK_DIR/assemblies/hifiasm/N13.asm.bp.p_ctg.fa
LJA_ASSEMBLY=$WORK_DIR/assemblies/LJA/assembly.fasta
REFERENCE_DIR=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
OUT_DIR=$WORK_DIR/compare_genomes

mkdir -p $OUT_DIR

# Map flye assembly to reference genome
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
nucmer --threads 6 --breaklen 1000 --mincluster 1000 --delta $OUT_DIR/flye.delta $REFERENCE_DIR $FLYE_ASSEMBLY

# Map hifiasm assembly to reference genome
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
nucmer --threads 6 --breaklen 1000 --mincluster 1000 --delta $OUT_DIR/hifiasm.delta $REFERENCE_DIR $HIFIASM_ASSEMBLY

# Map LJA assembly to reference genome
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
nucmer --threads 6 --breaklen 1000 --mincluster 1000 --delta $OUT_DIR/LJA.delta $REFERENCE_DIR $LJA_ASSEMBLY

# Create mummerplot for flye
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE_DIR -Q $FLYE_ASSEMBLY --fat --layout --filter --breaklen 1000 -t png --large -p $OUT_DIR/flye_plot $OUT_DIR/flye.delta

# Create mummerplot for hifiasm
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE_DIR -Q $HIFIASM_ASSEMBLY --fat --layout --filter --breaklen 1000 -t png --large -p $OUT_DIR/hifiasm_plot $OUT_DIR/hifiasm.delta

# Create mummerplot for LJA
apptainer exec --bind /data /containers/apptainer/mummer4_gnuplot.sif \
mummerplot -R $REFERENCE_DIR -Q $LJA_ASSEMBLY --fat --layout --filter --breaklen 1000 -t png --large -p $OUT_DIR/LJA_plot $OUT_DIR/LJA.delta




