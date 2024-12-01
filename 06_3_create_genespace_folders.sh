#!/usr/bin/env bash
#SBATCH --job-name=06_3_create_genespace_folders.sh
#SBATCH --output=../out/06_3_create_genespace_folders.out
#SBATCH --error=../err/06_3_create_genespace_folders.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kolsen/assembly_annotation_course"
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
FAI_FILE="/data/users/kolsen/assembly_annotation_course/assemblies/flye/assembly.fasta.fai"
GENE_FILE="/data/users/kolsen/assembly_annotation_course/MAKER/filtered.genes.renamed.final.gff3"
PROTEIN_FILE="/data/users/kolsen/assembly_annotation_course/MAKER/assembly.all.maker.proteins.fasta.renamed.filtered.longest.fasta"

# load modules
module load SeqKit/2.6.1
module load SAMtools/1.13-GCC-10.3.0

mkdir -p $WORKDIR/annotation_evaluation/genespace/peptide
mkdir -p $WORKDIR/annotation_evaluation/genespace/bed

cd $WORKDIR/assemblies/flye

# Create fai file for the assembly
samtools faidx /data/users/kolsen/assembly_annotation_course/assemblies/flye/assembly.fasta

cd $WORKDIR/annotation_evaluation/genespace

# load modules
module load SeqKit/2.6.1

mkdir -p $WORKDIR/annotation_evaluation/genespace/peptide
mkdir -p $WORKDIR/annotation_evaluation/genespace/bed

cd $WORKDIR/annotation_evaluation/genespace

## prepare the input files
# get 20 longest contigs
sort -k2,2 $FAI_FILE | cut -f1 | head -n20 > longest_contigs.txt

# create a bed file of all genes in the 20 longest contigs
grep -f longest_contigs.txt $GENE_FILE | awk 'NR > 1 && $3 == "gene" {gene_name = substr($9, 4, 13); print $1, $4, $5, gene_name}' > bed/genome1.bed

# Remove the trailing semicolon in the last column of genome1.bed
sed -i 's/;Na$//' bed/genome1.bed

# create a fasta file of these proteins
cut -f4 -d" " bed/genome1.bed > gene_list.txt
sed 's/-R.*//' $PROTEIN_FILE | seqkit grep -f gene_list.txt > peptide/genome1.fa

# copy the reference Arabidopsis files
cp $COURSEDIR/data/TAIR10.bed bed/
cp $COURSEDIR/data/TAIR10.fa peptide/

# copy the files from accession Kar-1 to compare
cp /data/users/okopp/assembly_annotation_course/genespace/bed/genome1.bed $WORKDIR/annotation_evaluation/genespace/bed/genome2.bed
cp /data/users/okopp/assembly_annotation_course/genespace/peptide/genome1.fa $WORKDIR/annotation_evaluation/genespace/peptide/genome2.fa