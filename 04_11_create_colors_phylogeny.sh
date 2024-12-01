#!/usr/bin/env bash
#SBATCH --job-name=04_11_phylogeny_analysis.sh
#SBATCH --output=../out/04_11_phylogeny_analysis.out
#SBATCH --error=../err/04_11_phylogeny_analysis.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

COLOR_DIR="/data/users/kolsen/assembly_annotation_course/EDTA_annotation/colors"
GYPSY_DIR="/data/users/kolsen/assembly_annotation_course/EDTA_annotation/results_TEsorter/Gypsy_sequences.fa.rexdb-plant.cls.tsv"
COPIA_DIR="/data/users/kolsen/assembly_annotation_course/EDTA_annotation/results_TEsorter/Copia_sequences.fa.rexdb-plant.cls.tsv"
GYPSY_BRASSIECACEAE="/data/users/kolsen/assembly_annotation_course/EDTA_annotation/Gypsy_sequences_Brassicaceae.fa.rexdb-plant.cls.tsv"
COPIA_BRASSIECACEAE="/data/users/kolsen/assembly_annotation_course/EDTA_annotation/Copia_sequences_Brassicaceae.fa.rexdb-plant.cls.tsv"
SUM_DIR="/data/users/kolsen/assembly_annotation_course/EDTA_annotation/assembly.fasta.mod.EDTA.TEanno.sum"

mkdir -p $COLOR_DIR

cd $COLOR_DIR

grep -h -e "Ale" $COPIA_DIR $COPIA_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #F94144 Ale/' > Ale_ID.txt

grep -h -e "Angela" $COPIA_DIR $COPIA_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #F3722C Angela/' > Angela_ID.txt

grep -h -e "Bianca" $COPIA_DIR $COPIA_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #F8961E Bianca/' > Bianca_ID.txt

grep -h -e "Ikeros" $COPIA_DIR $COPIA_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #F9C74F Ikeros/' > Ikeros_ID.txt

grep -h -e "Ivana" $COPIA_DIR $COPIA_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #90BE6D Ivana/' > Ivana_ID.txt

grep -h -e "SIRE" $COPIA_DIR $COPIA_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #43AA8B SIRE/' > SIRE_ID.txt

grep -h -e "Tork" $COPIA_DIR $COPIA_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #577590 Tork/' > Tork_ID.txt

grep -h -e "Athila" $GYPSY_DIR $GYPSY_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #F94144 Athila/' > Athila_ID.txt

grep -h -e "CRM" $GYPSY_DIR $GYPSY_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #F3722C CRM/' > CRM_ID.txt

grep -h-e "Reina" $GYPSY_DIR $GYPSY_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #F9C74F Reina/' > Reina_ID.txt

grep -h -e "Retand" $GYPSY_DIR $GYPSY_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #90BE6D Retand/' > Retand_ID.txt

grep -h -e "Tekay" $GYPSY_DIR $GYPSY_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #43AA8B Tekay/' > Tekay_ID.txt

grep -h -e "unknown" $GYPSY_DIR $GYPSY_BRASSIECACEAE |cut -f 1|sed 's/:/_/'|sed 's/#.*//'|sed 's/$/ #577590 unknown/' > unknown_ID.txt

# create the counts file
tail -n +31 $SUM_DIR | head -n -48 | awk '{print $1 "," $2}' > counts.txt