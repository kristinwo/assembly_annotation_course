#!/usr/bin/env bash
#SBATCH --job-name=03_3_merqury
#SBATCH --output=../out/03_3_merqury.out
#SBATCH --error=../err/03_3_merqury.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

WORK_DIR=/data/users/kolsen/assembly_annotation_course

READ_DIR=$WORK_DIR/N13/ERR11437334.fastq.gz

FLYE_ASSEMBLY=$WORK_DIR/assemblies/flye/assembly.fasta
HIFIASM_ASSEMBLY=$WORK_DIR/assemblies/hifiasm/N13.asm.bp.p_ctg.fa
LJA_ASSEMBLY=$WORK_DIR/assemblies/LJA/assembly.fasta

RESULT_DIR=$WORK_DIR/assembly_evaluation/mercury
MERYL=$RESULT_DIR/meryl.meryl

FLYE_OUT=$RESULT_DIR/flye
HIFIASM_OUT=$RESULT_DIR/hifiasm
LJA_OUT=$RESULT_DIR/LJA


mkdir -p $RESULT_DIR $FLYE_OUT $HIFIASM_OUT $LJA_OUT

export MERQURY="/usr/local/share/merqury"

# Find the best kmer (only needs to be done once)
#apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
#$MERQURY/best_k.sh 135000000

# k= 18.4864

#only needs to be done once:
#apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
#meryl k=18 count $READ_DIR output $RESULT_DIR/genome.meryl

cd $RESULT_DIR
# Run mercury on flye assembly
apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
sh $MERQURY/merqury.sh $RESULT_DIR/genome.meryl $FLYE_ASSEMBLY flye_

cd $RESULT_DIR
# Run mercury on hifiasm assembly
apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
sh $MERQURY/merqury.sh $RESULT_DIR/genome.meryl $HIFIASM_ASSEMBLY hifiasm_

cd $RESULT_DIR
# Run mercury on LJA assembly
apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
sh $MERQURY/merqury.sh $RESULT_DIR/genome.meryl $LJA_ASSEMBLY LJA_