#!/usr/bin/env bash
#SBATCH --job-name=03_2_quast
#SBATCH --output=../out/03_2_quast.out
#SBATCH --error=../err/03_2_quast.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course
FLYE_ASSEMBLY=$WORK_DIR/assemblies/flye/assembly.fasta
HIFIASM_ASSEMBLY=$WORK_DIR/assemblies/hifiasm/N13.asm.bp.p_ctg.fa
LJA_ASSEMBLY=$WORK_DIR/assemblies/LJA/assembly.fasta
OUT_DIR=$WORK_DIR/assembly_evaluation/quast
REFERENCE_DIR=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
FEATURES_DIR=/data/courses/assembly-annotation-course/references/TAIR10_GFF3_genes.gff

# Run quast on flye, hifiasm and LJA-assembly without reference genome
apptainer exec --bind /data /containers/apptainer/quast_5.2.0.sif \
quast.py -o $OUT_DIR/no_reference --eukaryote --no-sv --large --threads 4 --est-ref-size 135000000 --labels Flye,Hifiasm,LJA $FLYE_ASSEMBLY $HIFIASM_ASSEMBLY $LJA_ASSEMBLY

# Run quast on flye, hifiasm and LJA-assembly with reference genome
apptainer exec --bind /data /containers/apptainer/quast_5.2.0.sif \
quast.py -o $OUT_DIR/reference -r $REFERENCE_DIR --features $FEATURES_DIR --eukaryote --no-sv --large --threads 4 --est-ref-size 135000000 --labels Flye,Hifiasm,LJA $FLYE_ASSEMBLY $HIFIASM_ASSEMBLY $LJA_ASSEMBLY

