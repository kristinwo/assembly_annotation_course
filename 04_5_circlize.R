# Load necessary libraries
library(circlize)
library(tidyverse)
library(ComplexHeatmap)
library(stringr)

# Load GFF3 and clade data files
gff_file <- "./local/assembly.fasta.mod.EDTA.TEanno.gff3"
gff_data <- read.table(gff_file, header = FALSE, sep = "\t", stringsAsFactors = FALSE)
cls_file <- "./local/Gypsy_sequences.fa.rexdb-plant.cls.tsv"
cls_data <- read.table(cls_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE, comment.char = "")

# Load and prepare the custom ideogram data from the `.fai` file
fai_file <- "./local/assembly.fasta.fai"
custom_ideogram <- read.table(fai_file, header = FALSE, stringsAsFactors = FALSE) %>%
  rename(chr = V1, end = V2) %>%
  mutate(start = 1) %>%
  select(chr, start, end) %>%
  arrange(desc(end)) %>%
  slice(1:20)  # Use top 20 longest scaffolds

# Start PDF
pdf("./figures/circlize_plot.pdf", width = 10, height = 10)

# Initialize the circos plot with the custom ideogram
circos.genomicInitialize(custom_ideogram, plotType = c("axis", "labels"))

# Define superfamilies and clades with corresponding colors
superfamilies <- c("Gypsy_LTR_retrotransposon", "Copia_LTR_retrotransposon", 
                   "Mutator_TIR_transposon", "CACTA_TIR_transposon")
clades <- c("CRM", "Athila")

superfamily_colors <- c("darkblue", "darkgreen", "darkred", "darkorange")
clade_colors <- c("purple", "cyan4")

# Function to filter GFF data by superfamily
filter_superfamily <- function(data, superfamily, ideogram) {
  data %>%
    filter(V3 == superfamily) %>%
    transmute(chrom = V1, start = V4, end = V5) %>%
    filter(chrom %in% ideogram$chr)
}

# Prepare density data for each superfamily and plot for each of them
for (i in seq_along(superfamilies)) {
  track_data <- filter_superfamily(gff_data, superfamilies[i], custom_ideogram)
  circos.genomicDensity(track_data, col = superfamily_colors[i], track.height = 0.1, window.size = 5e4)
}

# Extract TE IDs from gff_data based on "Name="
gff_data <- gff_data %>%
  mutate(TE_ID = str_extract(V9, "(?<=Name=)[^;]+"))

# Extract TE name from cls_data
cls_data <- cls_data %>%
  mutate(TE_ID = str_extract(X.TE, "^[^#]+"))

# Function to filter and plot density for specified clade
plot_clade_density <- function(clade, color) {
  clade_cls_data <- cls_data %>%
    filter(Clade == clade) %>%
    pull(TE_ID)
  
  clade_gff_data <- gff_data %>%
    filter(TE_ID %in% clade_cls_data) %>%
    transmute(chrom = V1, start = V4, end = V5) %>%
    filter(chrom %in% custom_ideogram$chr) %>%
    na.omit()
  
  if (nrow(clade_gff_data) > 0) {
    circos.genomicDensity(clade_gff_data, count_by = "number", col = color, track.height = 0.07, window.size = 1e5)
  } else {
    message(paste("No data found for", clade, "clade in gff_data."))
  }
}

# Plot density for each clade with corresponding colors
plot_clade_density("CRM", clade_colors[1])
plot_clade_density("Athila", clade_colors[2])

# Add legend for colors without a box outline
legend("topright", legend = c(superfamilies, clades), 
       fill = c(superfamily_colors, clade_colors), 
       title = "", cex = 0.8, bty = "n")

# Clear the circos plot after use
circos.clear()

# Close PDF output
dev.off()

