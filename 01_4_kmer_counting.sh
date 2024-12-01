#!/usr/bin/env bash
#SBATCH --job-name=01_4_kmer_counting
#SBATCH --output=../out/01_4_kmer_counting.out
#SBATCH --error=../err/01_4_kmer_counting.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --partition=pibu_el8

WORKDIR=/data/users/kolsen/assembly_annotation_course
OUT_DIR=$WORKDIR/kmer
FILE=$WORKDIR/N13/ERR11437334.fastq.gz


# Run kmer count and kmer histo
apptainer exec \
--bind $WORKDIR \
/containers/apptainer/jellyfish:2.2.6--0 \
jellyfish count -C -m 21 -s 5G -t 4 -o $OUT_DIR/kmer_count_N13.jf <(zcat $FILE)

apptainer exec \
--bind $WORKDIR \
/containers/apptainer/jellyfish:2.2.6--0 \
jellyfish histo -t 4 $OUT_DIR/kmer_count_N13.jf > $OUT_DIR/kmer_N13.histo