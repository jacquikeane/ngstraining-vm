#!/bin/bash

set -eu

export MINICONDA="/home/miniconda/software"
source $MINICONDA/etc/profile.d/conda.sh

echo "Reading executables to test!"
while read -r line;
do
    echo "Checking ${line}"
    # Split line on comma into environment and executables
    IFS=',' read -a myarray <<<  $line
    environment=${myarray[0]}
    executables=${myarray[1]}
    # Load the conda environment
    conda activate $environment
    $executables
done <  executables.txt

set +eu
