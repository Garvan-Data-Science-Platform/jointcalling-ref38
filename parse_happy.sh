#!/bin/bash

set -eu -o pipefail

# Path to hap.py summary.csv file and output file
summary_file="happy_results/*summary.csv"
output_file=parsed_$(basename ${summary_file})

# Check if parsed summary file already exists
if [ -e ${output_file} ]; then
    echo "Error: File '${output_file}' already exists."
    exit 1
fi

failed=false
check_metric() {
    local metric_type=$1
    local threshold=$2
    local column=$3
    local label=$4

    metric_value=$(grep "${metric_type},PASS" ${summary_file} | cut -d, -f${column})
    if (( $(echo "${metric_value} < ${threshold}" | bc -l) )); then
        echo "[FAILED] ${label} BELOW THRESHOLD (${metric_value} < ${threshold})" | tee -a ${output_file}
        failed=true
    else
        echo "[PASSED] ${label} ABOVE THRESHOLD (${metric_value} > ${threshold})" | tee -a ${output_file}
    fi
}

# 1. SNP PASS Recall (sensitivity)      | Above 0.99
check_metric "SNP" 9999 10 "SNP PASS Recall"

# 2. SNP PASS Precision                 | Above 0.99
check_metric "SNP" 0.99 11 "SNP PASS Precision"

# 3. INDEL PASS Recall (sensitivity)    | Above 0.95
check_metric "INDEL" 9999 10 "INDEL PASS Recall"

# 4. INDEL PASS Precision               | Above 0.95
check_metric "INDEL" 0.95 11 "INDEL PASS Precision"

# If no metrics failed, exit with 0. Otherwise, exit with 1.
[ "${failed}" == false ] && exit 0 || exit 1