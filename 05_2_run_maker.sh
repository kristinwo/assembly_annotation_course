#!/usr/bin/env bash
#SBATCH --job-name=05_2_run_maker.sh
#SBATCH --output=../out/05_2_run_maker.out
#SBATCH --error=../err/05_2_run_maker.err
#SBATCH --ntasks-per-node=50
#SBATCH --mem=128G
#SBATCH --time=7-00:00:00
#SBATCH --partition=pibu_el8

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/kolsen/assembly_annotation_course/MAKER"
mkdir -p $WORKDIR
cd $WORKDIR

REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker"

module load OpenMPI/4.1.1-GCC-10.3.0
module load AUGUSTUS/3.4.0-foss-2021a

mpiexec --oversubscribe -n 50 apptainer exec \
--bind $SCRATCH:/TMP --bind $COURSEDIR --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR \
${COURSEDIR}/containers/MAKER_3.01.03.sif \
maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl