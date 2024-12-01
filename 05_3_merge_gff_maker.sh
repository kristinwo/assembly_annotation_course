#!/usr/bin/env bash
#SBATCH --job-name=05_3_merge_gff_maker.sh
#SBATCH --output=../out/05_3_merge_gff_maker.out
#SBATCH --error=../err/05_3_merge_gff_maker.err
#SBATCH --ntasks-per-node=50
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/kolsen/assembly_annotation_course/MAKER"
cd $WORKDIR

MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"
$MAKERBIN/gff3_merge -s -d assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.gff
$MAKERBIN/gff3_merge -n -s -d assembly.maker.output/assembly_master_datastore_index.log > assembly.all.maker.noseq.gff
$MAKERBIN/fasta_merge -d assembly.maker.output/assembly_master_datastore_index.log -o assembly
