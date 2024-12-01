library(tidyverse)
library(data.table)

# Load the data
anno_data=read.table("./local/assembly.fasta.mod.LTR.intact.gff3",header=F,sep="\t")
head(anno_data)
# Get the classification table
classification=fread("./local/assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv")

## NOTE:
# Or get the file by running the following command in bash:
# TEsorter assembly.fasta.mod.EDTA.raw/assembly.fasta.mod.LTR.intact.fa -db rexdb-plant
# It will be named as assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv
# Then run the following command in R:
# classification=fread("assembly.fasta.mod.EDTA.raw/assembly.fasta.mod.LTR.intact.fa.rexdb-plant.cls.tsv")

head(classification)
# Separate first column into two columns at "#", name the columns "Name" and "Classification"
names(classification)[1]="TE"
classification=classification%>%separate(TE,into=c("Name","Classification"),sep="#")


# Check the superfamilies present in the GFF3 file, and their counts
anno_data$V3 %>% table()

# Filter the data to select only TE superfamilies, (long_terminal_repeat, repeat_region and target_site_duplication are features of TE)
anno_data_filtered <- anno_data[!anno_data$V3 %in% c("long_terminal_repeat","repeat_region","target_site_duplication"), ]
nrow(anno_data_filtered)
# QUESTION: How Many TEs are there in the annotation file?
# 314

# Check the Clades present in the GFF3 file, and their counts
# select the feature column V9 and get the Name and Identity of the TE
anno_data_filtered$named_lists <- lapply(anno_data_filtered$V9, function(line) {
  setNames(
    sapply(strsplit(strsplit(line, ";")[[1]], "="), `[`, 2),
    sapply(strsplit(strsplit(line, ";")[[1]], "="), `[`, 1)
  )
})

anno_data_filtered$Name <- unlist(lapply(anno_data_filtered$named_lists, function(x) {
  x["Name"]
}))

anno_data_filtered$Identity <-unlist(lapply(anno_data_filtered$named_lists, function(x) {
  x["ltr_identity"]
}) )

anno_data_filtered$length <- anno_data_filtered$V5 - anno_data_filtered$V4

anno_data_filtered =anno_data_filtered %>%select(V1,V4,V5,V3,Name,Identity,length) 
head(anno_data_filtered)

# Merge the classification table with the annotation data
anno_data_filtered_classified=merge(anno_data_filtered,classification,by="Name",all.x=T)

table(anno_data_filtered_classified$Superfamily)
# QUESTION: Most abundant superfamilies are?
# Copia Gypsy 
# 153   148 

table(anno_data_filtered_classified$Clade)
# QUESTION: Most abundant clades are?
# Ale  Alesia  Angela  Athila  Bianca     CRM  Ikeros   Ivana   Reina  Retand 
# 62       1       1      69      27      15       1      24      23      24 
# SIRE     TAR   Tekay    Tork unknown 
# 7       2      13      26       6 

# Now plot the distribution of TE percent identity per clade 

anno_data_filtered_classified$Identity=as.numeric(as.character(anno_data_filtered_classified$Identity))

anno_data_filtered_classified$Clade=as.factor(anno_data_filtered_classified$Clade)

anno_data_filtered_classified <- na.omit(anno_data_filtered_classified)

# Create a plot with different colors for each Superfamily
ggplot(anno_data_filtered_classified, aes(x = Identity, fill = Superfamily)) +
  geom_histogram(color = "black", bins = 10) +  # Map fill to Superfamily
  facet_grid(Superfamily ~ .) +  
  cowplot::theme_cowplot() +
  scale_fill_brewer(palette = "Set1")# Optional: use a predefined color palette

# Save the plots
ggsave("./figures/01_full-length-LTR-RT-superfamily.pdf", width = 10, height = 8, units = 'cm')
ggsave("./figures/01_full-length-LTR-RT-superfamily.png", width = 10, height = 8, units = 'cm')

dev.off()



# Create plots for each Clade with different colors for Superfamilies
ggplot(anno_data_filtered_classified[anno_data_filtered_classified$Superfamily != "unknown", ], 
                  aes(x = Identity, fill = Superfamily)) +  # Fill based on Superfamily
  geom_histogram(color = "black", bins = 10) +  # Adjust bins as needed
  facet_wrap(~ Clade) +  # Facet by Clade
  cowplot::theme_cowplot() +
  scale_fill_brewer(palette = "Set1") +  # Different colors for Superfamilies
  theme(strip.text = element_text(size = 10))  # Optional: adjust text size for better readability

# Save the plots
ggsave("./figures/01_full-length-LTR-RT-clades.pdf", width = 20, height = 15, units = 'cm')
ggsave("./figures/01_full-length-LTR-RT-clades.png", width = 20, height = 15, units = 'cm')

dev.off()

