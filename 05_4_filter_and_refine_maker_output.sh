#!/usr/bin/env bash
#SBATCH --job-name=05_4_filter_and_refine_maker_output.sh
#SBATCH --output=../out/05_4_filter_and_refine_maker_output.out
#SBATCH --error=../err/05_4_filter_and_refine_maker_output.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/kolsen/assembly_annotation_course
COURSEDIR=/data/courses/assembly-annotation-course/CDS_annotation
final=$WORKDIR/MAKER
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

prefix=N13 
protein=assembly.all.maker.proteins.fasta
transcript=assembly.all.maker.transcripts.fasta
gff=assembly.all.maker.noseq.gff

module load UCSC-Utils/448-foss-2021a
module load BioPerl/1.7.8-GCCcore-10.3.0
module load MariaDB/10.6.4-GCC-10.3.0

mkdir -p $final
cd $final

cp ../MAKER/$gff ${gff}.renamed.gff
cp ../MAKER/$protein ${protein}.renamed.fasta 
cp ../MAKER/$transcript ${transcript}.renamed.fasta

# Assign clean, consistent IDs to the gene models
$MAKERBIN/maker_map_ids --prefix $prefix --justify 7 $gff.renamed.gff > id.map
$MAKERBIN/map_gff_ids id.map $gff.renamed.gff
$MAKERBIN/map_fasta_ids id.map ${protein}.renamed.fasta
$MAKERBIN/map_fasta_ids id.map ${transcript}.renamed.fasta

# Run InterProScan on the Protein File
apptainer exec \
    --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
    --bind $WORKDIR \
    --bind $COURSEDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/interproscan_latest.sif \
    /opt/interproscan/interproscan.sh \
    -appl pfam --disable-precalc -f TSV \
    --goterms --iprlookup --seqtype p \
    -i ${protein}.renamed.fasta -o output.iprscan


# Update the GFF file with InterProScan results
$MAKERBIN/ipr_update_gff ${gff}.renamed.gff output.iprscan > ${gff}.renamed.iprscan.gff

# Calculate AED values
perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 ${gff}.renamed.gff > assembly.all.maker.renamed.gff.AED.txt

# Filter the gff file based on AED values for Quality
QUALITY_FILTER=/data/users/kolsen/assembly_annotation_course/scripts/quality_filter.pl

perl $QUALITY_FILTER -s ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff


# The gff also contains other features like Repeats, and match hints from different sources of evidence
# Let's see what are the different types of features in the gff file
cut -f3 ${gff}_iprscan_quality_filtered.gff | sort | uniq

# We only want to keep gene features in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

# We need to add back the gff3 header to the filtered gff file so that it can be used by other tools
grep "^#" ${gff}_iprscan_quality_filtered.gff > header.txt
cat header.txt filtered.genes.renamed.gff3 > filtered.genes.renamed.final.gff3

# Extract mRNA Sequences and Filter FASTA Files
grep -P "\tmRNA\t" filtered.genes.renamed.final.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' >mRNA_list.txt
faSomeRecords ${transcript}.renamed.fasta mRNA_list.txt ${transcript}.renamed.filtered.fasta
faSomeRecords ${protein}.renamed.fasta mRNA_list.txt ${protein}.renamed.filtered.fasta


