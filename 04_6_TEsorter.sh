#!/usr/bin/env bash
#SBATCH --job-name=04_6_TEsorter.sh
#SBATCH --output=../out/04_6_TEsorter.out
#SBATCH --error=../err/04_6_TEsorter.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORK_DIR="/data/users/kolsen/assembly_annotation_course/EDTA_annotation"

cd $WORK_DIR

module load SeqKit/2.6.1

# Extract Copia sequences
seqkit grep -r -p "Copia" $WORK_DIR/assembly.fasta.mod.EDTA.TElib.fa > Copia_sequences.fa

# Extract Gypsy sequences
seqkit grep -r -p "Gypsy" $WORK_DIR/assembly.fasta.mod.EDTA.TElib.fa > Gypsy_sequences.fa

# Run TEsorter on Copia file
apptainer exec -C -H $WORK_DIR -H ${pwd}:/work --writable-tmpfs -u \
/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif TEsorter Copia_sequences.fa -db rexdb-plant

# Run TEsorter on Gypsy file
apptainer exec -C -H $WORK_DIR -H ${pwd}:/work --writable-tmpfs -u \
/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif TEsorter Gypsy_sequences.fa -db rexdb-plant



