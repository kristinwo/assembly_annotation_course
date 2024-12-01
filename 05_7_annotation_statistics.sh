#!/usr/bin/env bash
#SBATCH --job-name=05_7_annotation_statistics.sh
#SBATCH --output=../out/05_7_annotation_statistics.out
#SBATCH --error=../err/05_7_annotaiton_statistics.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

ANNOTATION="/data/users/kolsen/assembly_annotation_course/MAKER/assembly.all.maker.gff"
ANNOTATION_FILTERED="/data/users/kolsen/assembly_annotation_course/MAKER/filtered.genes.renamed.final.gff3"
ANNOTATION_BLAST="/data/users/kolsen/assembly_annotation_course/MAKER/maker_proteins.fasta.Uniprot"
OUTPUT_DIR="/data/users/kolsen/assembly_annotation_course/MAKER"

# Number of genes after filtering
awk '$3 == "gene" {count++} END {print "gene: " count}' $ANNOTATION_FILTERED > $OUTPUT_DIR/stats.txt

# Number of genes before filtering
awk '$3 == "gene" {count++} END {print "unfiltered genes: " count}' $ANNOTATION >> $OUTPUT_DIR/stats.txt

# Number of genes with blast hits
#awk '$3 == "gene" {count++} END {print "genes with blast hit: " count}' $ANNOTATION_BLAST >> $OUTPUT_DIR/stats.txt
grep -P 'Similar to' $ANNOTATION_BLAST | wc -l >> $OUTPUT_DIR/stats.txt

# Number of genes without blast hits
grep -P 'Protein of unknown function' $ANNOTATION_BLAST | wc -l >> $OUTPUT_DIR/stats.txt

# Number of mRNAs
awk '$3 == "mRNA" {count++} END {print "mRNA: " count}' $ANNOTATION >> $OUTPUT_DIR/stats.txt

# Number of genes with functional annotation
awk '$3 == "gene" {print $9}' $ANNOTATION | grep -c "InterPro" >> $OUTPUT_DIR/stats.txt

# Median, max, min of gene length, mRNA length, exon length
awk '$3 == "gene" { print $5 - $4 + 1 }' $ANNOTATION > $OUTPUT_DIR/gene_lengths.txt
awk '$3 == "mRNA" { print $5 - $4 + 1 }' $ANNOTATION > $OUTPUT_DIR/mRNA_lengths.txt
awk '$3 == "exon" { print $5 - $4 + 1 }' $ANNOTATION > $OUTPUT_DIR/exon_lengths.txt

# Intron lengths
awk '$3 == "exon" { split($9, a, ";"); 
    for (i in a) if (a[i] ~ /^Parent=/) parent=substr(a[i], 8);
    print parent, $4, $5 }' $ANNOTATION | sort -k1,1 -k2,2n | \
awk '{ if ($1 == prev_parent) {
        intron_length = $2 - prev_end - 1;
        print intron_length
    }
    prev_parent = $1;
    prev_end = $3}' > $OUTPUT_DIR/intron_lengths.txt

# Number of exons per gene
awk '$3 == "exon" { split($9, a, ";"); 
    for (i in a) if (a[i] ~ /^Parent=/) parent=substr(a[i], 8);
    print parent }' $ANNOTATION | sort | uniq -c > $OUTPUT_DIR/exon_counts.txt

# Number of monoexonic genes
awk '$1==1 {single_exon_count++} END {print single_exon_count}' $OUTPUT_DIR/exon_counts.txt > $OUTPUT_DIR/monoexonic_genes.txt