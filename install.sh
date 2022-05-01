#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

# Install singularity as root

./install_conda_software.sh
./check_conda_software.sh

./install_conda_profiles.sh

./install_bio_metagenomics.sh
./install_deago.sh
./install_plamid_ec.sh
./install_qualifyr.sh
./install_remove_blocks.sh
./install_sh16_bactgen_scripts.sh
./install_signalp.sh

./set_up_databases.sh

./install_nf_pipelines.sh
