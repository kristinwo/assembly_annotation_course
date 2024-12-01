library(ggplot2)
library(dplyr)
library(readr)

# Read TEanno.sum file for the abundance of each TE
sum_file <- "./local/assembly.fasta.mod.EDTA.TEanno.sum"
sum_data <- read_table(sum_file, col_names=FALSE, skip = 30)
colnames(sum_data) <- c("ID", "Count", "bpMasked", "%masked")
sum_data <- sum_data %>%
  select(-5) # Remove column 5 containing only NAs

# Read gypsy and copia data containing information about the clades
copia_file <- "./local/Copia_sequences.fa.rexdb-plant.cls.tsv"
copia_data <- read.table(copia_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE, comment.char = "")
gypsy_file <- "./local/Gypsy_sequences.fa.rexdb-plant.cls.tsv"
gypsy_data <- read.table(gypsy_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE, comment.char = "")

# Extract TE name from copia_data and gypsy_data before the second underscore
copia_data <- copia_data %>%
  mutate(TE_ID = str_extract(X.TE, "^[^#]+"))

gypsy_data <- gypsy_data %>%
  mutate(TE_ID = str_extract(X.TE, "^[^#]+"))


# Merge copia and gypsy data with sum_data to add clade information
sum_data <- sum_data %>%
  left_join(copia_data %>% select(TE_ID, Clade) %>% rename(copia_clade = Clade), by = c("ID" = "TE_ID")) %>%
  left_join(gypsy_data %>% select(TE_ID, Clade) %>% rename(gypsy_clade = Clade), by = c("ID" = "TE_ID"))

# Filter for Gypsy clade data
gypsy_sum <- sum_data %>% 
  filter(!is.na(gypsy_clade)) %>%
  group_by(gypsy_clade) %>%
  summarise(total_count = sum(Count, na.rm = TRUE))

# Filter for Copia clade data
copia_sum <- sum_data %>% 
  filter(!is.na(copia_clade)) %>%
  group_by(copia_clade) %>%
  summarise(total_count = sum(Count, na.rm = TRUE))

# Plot for Gypsy clade
ggplot(gypsy_sum, aes(x = gypsy_clade, y = total_count, fill = gypsy_clade)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "", x = "Gypsy Clades", y = "Abundance (total counts)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_discrete(name = "Gypsy Clades") +
  theme(legend.position = "right")

# Save the plot
ggsave("./figures/gypsy_clade_abundance.pdf", width = 15, height = 10, units = 'cm')
ggsave("./figures/gypsy_clade_abundance.png", width = 15, height = 10, units = 'cm')


# Plot for Copia clade
ggplot(copia_sum, aes(x = copia_clade, y = total_count, fill = copia_clade)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "", x = "Copia Clades", y = "Abundance (total counts)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_discrete(name = "Copia Clades") +
  theme(legend.position = "right")

# Save the plot
ggsave("./figures/copia_clade_abundance.pdf", width = 15, height = 10, units = 'cm')
ggsave("./figures/copia_clade_abundance.png", width = 15, height = 10, units = 'cm')

