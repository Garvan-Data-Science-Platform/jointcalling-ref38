#!/bin/bash
#PBS -S /bin/bash
#PBS -q normal
#PBS -P np30
#PBS -l storage=scratch/np30+gdata/np30+massdata/np30
#PBS -l wd

module unload java
module unload python3

module load java
module load python3/3.8.5
module load nextflow
module load singularity
module load intel-mkl/2020.2.254
module load gatk

set -eu -o pipefail

echo "Move to correct directory ..."
cd $INSTANCE_PARENT/$REPO

echo "Run pipeline ..."
nextflow run JointCaller.nf -c nci_configs/JointCaller.hg38.local.config --sample_name_map sample_inputs/sample_name_map --callset_name jointCallRef38 -profile gadi,gatk4 -resume
