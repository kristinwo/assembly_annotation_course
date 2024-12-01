# Assembly and Annotation of the N13 Accession of *Arabidopsis thaliana*

This project is part of the following courses:
- **Genome Assembly** (473637) Univerisity of Bern 
- **Organization and Annotation of Eukaryote Genomes** (SBL.30004)  University of Fribourg

## Abstract

Advances in long-read sequencing have enabled high-quality genome assemblies and detailed studies of structural variation in *Arabidopsis thaliana*. Recently, Lian et al. (2024) assembled 69 *Arabidopsis thaliana* accessions. In this study, we used the N13 accession from Lian et al. (2024) to create three assemblies using Flye, Hifiasm, and LJA, and then performed TE and gene annotation. The results show good quality of the assembly and annotation, with indications of fragmentation in the genome assembly. Comparing the results to other accessions revealed a constant percentage of TEs across accessions and unique genetic characteristics for the Rab-R1 accession from Madeira, likely due to isolated evolution. The findings are highly consistent with those of Lian et al. (2024), demonstrating good reproducibility of the results.

## Scripts

The following scripts were used in the project:

### Quality Control and K-mer Counting
- `01_1_run_fastqc.sh`
- `01_2_run_fastp_paired_end.sh`
- `01_3_run_fastp_single_end.sh`
- `01_4_kmer_counting.sh`

### Assembly
- `02_1_flye.sh`
- `02_2_hifiasm.sh`
- `02_3_LJA.sh`
- `02_4_trinity.sh`

### Assembly Evaluation
- `03_1_busco.sh`
- `03_2_quast.sh`
- `03_3_merqury.sh`
- `03_4_mummer.sh`

### TE Annotation and Visualization
- `04_1_EDTA.sh`
- `04_2_generate_clade_classifiaction_file.sh`
- `04_3_LTR_RTs_histograms.R`
- `04_4_create_fai_file.sh`
- `04_5_circlize.R`
- `04_6_TEsorter.sh`
- `04_7_TE_clades_abundance_between_accessions.R`
- `04_8_run_parseRM.sh`
- `04_9_TE_landscape_plot.R`
- `04_10_phylogeny_analysis.sh`
- `04_11_create_colors_phylogeny.sh`

### Gene Annotation
- `05_1_create_control_files.sh`
- `05_2_run_maker.sh`
- `05_3_merge_gff_maker.sh`
- `05_4_filter_and_refine_maker_output.sh`
- `05_5_busco_maker.sh`
- `05_6_blast_maker.sh`
- `05_7_annotation_statistics.sh`
- `05_8_busco_plots.sh`

### Comparative Genomics
- `06_1_OMArk.sh`
- `06_2_omark_contextualize.sh`
- `06_3_create_genespace_folders.sh`
- `06_4_run_genespace.sh`
- `06_5_genespace.R`
- `06_6_parse_orthofinder.R`
- `06_7_run_parse_orthofinder.sh`

## References
Data used for this project can be found in:

[Lian et al. (2024)] (https://www.nature.com/articles/s41588-024-01715-9): A pan-genome of 69 Arabidopsis thaliana accessions reveals a conserved genome structure throughout the global species range 

[Jiao and Schneeberger (2020)] (https://www.nature.com/articles/s41467-020-14779-y): Chromosome-level assemblies of multiple Arabidopsis genomes reveal hotspots of rearrangements with altered evolutionary dynamics

