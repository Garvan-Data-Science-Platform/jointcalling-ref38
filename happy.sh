#!/bin/bash
#PBS -S /bin/bash
#PBS -q normal
#PBS -P np30
#PBS -l storage=scratch/np30+gdata/np30+massdata/np30
#PBS -l wd

set -eu -o pipefail

query_vcf=$1
truth_vcf=/scratch/np30/eu1813/happy/ref38/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_PGandRTGphasetransfer.vcf.gz

# Confident call regions
bed_file=/scratch/np30/eu1813/happy/ref38/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_nosomaticdel_noCENorHET7.bed

# Reference FASTA
ref=/scratch/np30/eu1813/happy/ref38/Homo_sapiens_assembly38.fasta

# Restrict analysis to given regions
regions=/scratch/np30/eu1813/happy/ref38/reportable_range-1.0.hg38.chr21.bed

# Create results dir
mkdir happy_results

singularity exec -B ${PWD} /scratch/np30/eu1813/happy/hap.py_latest.sif \
    /opt/hap.py/bin/hap.py \
    ${truth_vcf} \
    ${query_vcf} \
    -f ${bed_file} \
    -V \
    -o "happy_results/NA12878_chr21" \
    -r ${ref} \
    -T ${regions} 