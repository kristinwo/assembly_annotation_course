#!/usr/bin/env bash
#SBATCH --job-name=06_1_OMArk.sh
#SBATCH --output=../out/06_1_OMArk.out
#SBATCH --error=../err/06_1_OMArk.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/kolsen/assembly_annotation_course
OUTDIR=$WORKDIR/OMArk
protein=$WORKDIR/MAKER/assembly.all.maker.proteins.fasta.renamed.filtered.fasta

mkdir -p $OUTDIR

eval "$(/home/amaalouf/miniconda3/bin/conda shell.bash hook)"
conda activate OMArk

cd $OUTDIR
#wget https://omabrowser.org/All/LUCA.h5

omamer search --db LUCA.h5 --query ${protein} --out $OUTDIR/assembly.all.maker.proteins.renamed.filtered.fasta.omamer

# Create the isoforms file
grep '^>' $protein | cut -c2- | cut -f1 -d" " | sort | \
awk 'BEGIN { ORS=""; OFS="" } NR == 1 {print $1 }; NR > 1 {gene = substr($1,1,14); if (gene == last_gene){print ";", $1} else {print "\n", $1}; last_gene = gene}' > isoform_list.txt

# Run OMArk
omark -f assembly.all.maker.proteins.renamed.filtered.fasta.omamer -of ${protein} -i isoform_list.txt -d LUCA.h5 -o omark_output