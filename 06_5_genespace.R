library(GENESPACE)
args <- commandArgs(trailingOnly = TRUE)
# get the folder where the genespace files are
wd <- args[1]
gpar <- init_genespace(wd = wd, path2mcscanx = "/data/users/kolsen/assembly_annotation_course/scripts/MCScanX", nCores = 20, verbose = TRUE)
out <- run_genespace(gpar, overwrite = TRUE)
