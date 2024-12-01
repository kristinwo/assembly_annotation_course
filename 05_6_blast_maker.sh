#!/usr/bin/env bash
#SBATCH --job-name=05_6_blast_maker.sh
#SBATCH --output=../out/05_6_blast_maker.out
#SBATCH --error=../err/05_6_blast_maker.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/kolsen/assembly_annotation_course
PROTEINS=$WORKDIR/MAKER/assembly.all.maker.proteins.fasta.renamed.filtered.fasta
FILTERED=$WORKDIR/MAKER/filtered.genes.renamed.final.gff3
OUTDIR=$WORKDIR/blast_maker
MAKERBIN="/data/courses/assembly-annotation-course/CDS_annotation/softwares/Maker_v3.01.03/src/bin"
UNIPROT=/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa
BLAST=$OUTDIR/blastp

mkdir -p $OUTDIR

module load BLAST+/2.15.0-gompi-2021a

blastp -query $PROTEINS -db $UNIPROT -num_threads 10 -outfmt 6 -evalue 1e-10 -out $OUTDIR/blastp

cp $PROTEINS $WORKDIR/MAKER/maker_proteins.fasta.Uniprot
cp $FILTERED $WORKDIR/MAKER/filtered.maker.gff3.Uniprot

$MAKERBIN/maker_functional_fasta $UNIPROT $BLAST $PROTEINS > $WORKDIR/MAKER/maker_proteins.fasta.Uniprot
$MAKERBIN/maker_functional_gff $UNIPROT $BLAST $FILTERED > $WORKDIR/MAKER/filtered.maker.gff3.Uniprot