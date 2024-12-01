#!/usr/bin/env bash
#SBATCH --job-name=05_8_busco_plots.sh
#SBATCH --output=../out/05_8_busco_plots.out
#SBATCH --error=../err/05_8_busco_plots.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8

OUTDIR="/data/users/kolsen/assembly_annotation_course/busco_maker"
PLOTDIR="/data/users/kolsen/assembly_annotation_course/busco_maker/plots"

# load the modules
module load BUSCO/5.4.2-foss-2021a
module load SeqKit/2.6.1

## create busco plot
# copy the busco short_summary files to the plot folder
cp $OUTDIR/transcripts/short_summary.specific.brassicales_odb10.transcripts.txt $PLOTDIR/.
cp $OUTDIR/proteins/short_summary.specific.brassicales_odb10.proteins.txt $PLOTDIR/.

# move to the plot directory and download the generate_plot.py script from the BUSCO GitHub
cd $PLOTDIR
#wget https://gitlab.com/ezlab/busco/-/raw/master/scripts/generate_plot.py

python3 generate_plot.py -wd $PLOTDIR