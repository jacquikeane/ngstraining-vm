#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

# Install singularity as root

./install_conda_software.sh
./check_conda_software.sh

conda activate bactopia
bactopia download

./install_bio_metagenomics.sh
./install_qualifyr.sh
./install_remove_blocks.sh

./set_up_databases.sh

./install_nf_pipelines.sh

./setup_references.sh
