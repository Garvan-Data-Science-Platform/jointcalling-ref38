#!/bin/bash
#PBS -S /bin/bash
#PBS -q normal
#PBS -P np30
#PBS -l storage=scratch/np30+gdata/np30+massdata/np30
#PBS -l wd
#PBS -l mem=32GB
#PBS -l ncpus=4

set -eu -o pipefail

echo "Move to correct directory ..."
cd $INSTANCE_PARENT/$REPO

echo "Create happy_results directory ..."
mkdir happy_results

echo "Run hap.py on VCF ..."
singularity exec -B ${PWD} /scratch/np30/eu1813/happy/hap.py_latest.sif \
    /opt/hap.py/bin/hap.py \
    ${TRUTH_VCF} \
    ${QUERY_VCF} \
    -f ${BED_FILE} \
    -V \
    -o "happy_results/$(basename ${QUERY_VCF} .vcf.gz)" \
    -r ${REF} \
    -T ${REGIONS} 