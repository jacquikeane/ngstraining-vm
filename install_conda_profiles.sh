#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Create bespoke conda profiles
echo "Reading conda profile list!"
while read -r line;
do
    echo "Creating ${line}"
    # Split line on comma into environment and software list
    IFS=',' read -a myarray <<<  $line
    environment=${myarray[0]}
    software=${myarray[1]}
    # Create a new conda environment with the software
    conda create -n $environment $software
done < profiles.txt

set +eu
