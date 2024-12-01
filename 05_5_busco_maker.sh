#!/usr/bin/env bash
#SBATCH --job-name=05_5_busco_maker.sh
#SBATCH --output=../out/05_5_busco_maker.out
#SBATCH --error=../err/05_5_busco_maker.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kolsen/assembly_annotation_course/MAKER"
OUTDIR="/data/users/kolsen/assembly_annotation_course/busco_maker"
PLOTDIR="/data/users/kolsen/assembly_annotation_course/busco_maker/plots"

mkdir -p $OUTDIR
mkdir -p $PLOTDIR
mkdir -p $OUTDIR/transcripts
mkdir -p $OUTDIR/proteins

cd $OUTDIR

# load the modules
module load BUSCO/5.4.2-foss-2021a
module load SeqKit/2.6.1

# create file with the longest transcripts
seqkit fx2tab -nl $WORKDIR/assembly.all.maker.transcripts.fasta.renamed.filtered.fasta > $OUTDIR/transcript_lengths.tsv
awk '{gene = substr($1,1,13); print $1, $7, gene}' $OUTDIR/transcript_lengths.tsv | sort -k3,3 | uniq -f2 | cut -f1 -d" " > $OUTDIR/longest_transcripts.txt

seqkit grep -f $OUTDIR/longest_transcripts.txt $WORKDIR/assembly.all.maker.transcripts.fasta.renamed.filtered.fasta > $WORKDIR/assembly.all.maker.transcripts.fasta.renamed.filtered.longest.fasta

# same for proteins
seqkit fx2tab -nl $WORKDIR/assembly.all.maker.proteins.fasta.renamed.filtered.fasta > $OUTDIR/protein_lengths.tsv
awk '{gene = substr($1,1,13); print $1, $6, gene}' $OUTDIR/protein_lengths.tsv | sort -k3,3 | uniq -f2 | cut -f1 -d" " > $OUTDIR/longest_proteins.txt

seqkit grep -f $OUTDIR/longest_proteins.txt $WORKDIR/assembly.all.maker.proteins.fasta.renamed.filtered.fasta > $WORKDIR/assembly.all.maker.proteins.fasta.renamed.filtered.longest.fasta

# run BUSCO on the longest proteins and longest transcripts
busco -i $WORKDIR/assembly.all.maker.transcripts.fasta.renamed.filtered.longest.fasta -l brassicales_odb10 -o transcripts -m transcriptome -f
busco -i $WORKDIR/assembly.all.maker.proteins.fasta.renamed.filtered.longest.fasta -l brassicales_odb10 -o proteins -m proteins -f

