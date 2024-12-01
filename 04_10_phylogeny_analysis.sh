#!/usr/bin/env bash
#SBATCH --job-name=04_10_phylogeny_analysis.sh
#SBATCH --output=../out/04_10_phylogeny_analysis.out
#SBATCH --error=../err/04_10_phylogeny_analysis.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
 
WORK_DIR="/data/users/kolsen/assembly_annotation_course/EDTA_annotation"
REF_DIR="/data/courses/assembly-annotation-course/CDS_annotation/data/Brassicaceae_repbase_all_march2019.fasta"
CONTAINER_DIR="/data/courses/assembly-annotation-course/containers2/TEsorter_1.3.0.sif"

# Load modules
module load SeqKit/2.6.1
module load Clustal-Omega/1.2.4-GCC-10.3.0
module load FastTree/2.1.11-GCCcore-10.3.0

# Copia RT sequences (Ty1-RT)
grep Ty1-RT $WORK_DIR/Copia_sequences.fa.rexdb-plant.dom.faa > $WORK_DIR/copia_list.txt
sed -i 's/>//' $WORK_DIR/copia_list.txt
sed -i 's/ .\+//' $WORK_DIR/copia_list.txt
seqkit grep -f $WORK_DIR/copia_list.txt $WORK_DIR/Copia_sequences.fa.rexdb-plant.dom.faa -o $WORK_DIR/Copia_RT.fasta
 
# Gypsy RT sequences (Ty3-RT)
grep Ty3-RT $WORK_DIR/Gypsy_sequences.fa.rexdb-plant.dom.faa > $WORK_DIR/gypsy_list.txt
sed -i 's/>//' $WORK_DIR/gypsy_list.txt
sed -i 's/ .\+//' $WORK_DIR/gypsy_list.txt
seqkit grep -f $WORK_DIR/gypsy_list.txt $WORK_DIR/Gypsy_sequences.fa.rexdb-plant.dom.faa -o $WORK_DIR/Gypsy_RT.fasta

# get Copia and Gypsy elements from Brassicaceae
seqkit grep -r -p "Copia" $REF_DIR > $OUTDIR/Copia_Brassicaceae.fa
seqkit grep -r -p "Gypsy" $REF_DIR > $OUTDIR/Gypsy_Brassicaceae.fa

cd $WORK_DIR
# TEsorter for Copia and Gypsy from Brassicaceae
apptainer exec --bind /data --writable-tmpfs -u $CONTAINER_DIR TEsorter $WORK_DIR/Copia_Brassicaceae.fa -db rexdb-plant
apptainer exec --bind /data --writable-tmpfs -u $CONTAINER_DIR TEsorter $WORK_DIR/Gypsy_Brassicaceae.fa -db rexdb-plant

# Extract RT sequences for Copia (Ty1-RT) from Brassicaceae
grep Ty1-RT $WORK_DIR/Copia_sequences_Brassicaceae.rexdb-plant.dom.faa > $WORK_DIR/copia_brass_list.txt
sed -i 's/>//' $WORK_DIR/copia_brass_list.txt
sed -i 's/ .\+//' $WORK_DIR/copia_brass_list.txt
seqkit grep -f $WORK_DIR/copia_brass_list.txt $WORK_DIR/Copia_sequences_Brassicaceae.fa.rexdb-plant.dom.faa -o $WORK_DIR/Copia_brass_RT.fasta

# Extract RT sequences for Gypsy (Ty3-RT) from Brassicaceae
grep Ty3-RT $WORK_DIR/Gypsy_sequences_Brassicaceae.fa.rexdb-plant.dom.faa >$WORK_DIR/gypsy_brass_list.txt
sed -i 's/>//' $WORK_DIR/gypsy_brass_list.txt
sed -i 's/ .\+//' $WORK_DIR/gypsy_brass_list.txt
seqkit grep -f $WORK_DIR/gypsy_brass_list.txt $WORK_DIR/Gypsy_sequences_Brassicaceae.fa.rexdb-plant.dom.faa -o $WORK_DIR/Gypsy_brass_RT.fasta

# Concatenate RT Sequences from Brassicaceae and Arabidopsis
cat $WORK_DIR/Copia_RT.fasta $WORK_DIR/Copia_brass_RT.fasta > $WORK_DIR/All_Copia_RT.fasta
cat $WORK_DIR/Gypsy_RT.fasta $WORK_DIR/Gypsy_brass_RT.fasta > $WORK_DIR/All_Gypsy_RT.fasta

# Shorten the TE identifiers and replace : with _
sed -i 's/#.\+//' $WORK_DIR/All_Copia_RT.fasta
sed -i 's/|.\+//' $WORK_DIR/All_Copia_RT.fasta

sed -i 's/#.\+//' $WORK_DIR/All_Gypsy_RT.fasta
sed -i 's/|.\+//' $WORK_DIR/All_Gypsy_RT.fasta

# Clustal Omega for multiple sequence alignment
clustalo -i $WORK_DIR/All_Copia_RT.fasta -o $WORK_DIR/Copia_RT_aligned.fasta --outfmt=fasta
clustalo -i $WORK_DIR/All_Gypsy_RT.fasta -o $WORK_DIR/Gypsy_RT_aligned.fasta --outfmt=fasta

# FastTree to build phylogenetic trees
FastTree -out $WORK_DIR/Copia_tree.nwk $WORK_DIR/Copia_RT_aligned.fasta
FastTree -out $WORK_DIR/Gypsy_tree.nwk $WORK_DIR/Gypsy_RT_aligned.fasta