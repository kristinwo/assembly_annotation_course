#!/usr/bin/env bash
#SBATCH --job-name=03_1_busco
#SBATCH --output=../out/03_1_busco.out
#SBATCH --error=../err/03_1_busco.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=64G
#SBATCH --time=05:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course
FLYE_ASSEMBLY=$WORK_DIR/assemblies/flye/assembly.fasta
HIFIASM_ASSEMBLY=$WORK_DIR/assemblies/hifiasm/N13.asm.bp.p_ctg.fa
LJA_ASSEMBLY=$WORK_DIR/assemblies/LJA/assembly.fasta
TRINITY_ASSEMBLY=$WORK_DIR/assemblies/trinity/trinity_out_dir.Trinity.fasta
OUT_FLYE=/assembly_evaluation/busco/flye
OUT_HIFIASM=/assembly_evaluation/busco/hifiasm
OUT_LJA=/assembly_evaluation/busco/LJA
OUT_TRINITY=/assembly_evaluation/busco/trinity

module load BUSCO/5.4.2-foss-2021a

# Run busco on flye-assembly
busco -i $FLYE_ASSEMBLY -o $OUT_FLYE --mode genome --lineage_dataset brassicales_odb10 --cpu 32

# Run busco on hifiasm-assembly
busco -i $HIFIASM_ASSEMBLY -o $OUT_HIFIASM --mode genome --lineage_dataset brassicales_odb10 --cpu 32

# Run busco on LJA-assembly
busco -i $LJA_ASSEMBLY -o $OUT_LJA --mode genome --lineage_dataset brassicales_odb10 --cpu 32

# Run busco on trinity-assembly
busco -i $TRINITY_ASSEMBLY -o $OUT_TRINITY --mode transcriptome --lineage_dataset brassicales_odb10 --cpu 32

