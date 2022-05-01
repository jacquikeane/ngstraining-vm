#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Get the source for plasmid EC and symlink to executables

# Create conda environments for plasmidEC                
conda env create --file=/home/software/src/plasmidEC-1.1/yml/plasmidEC_mlplasmids.yml
conda create --name plasmidEC_plascope -c bioconda/label/cf201901 plascope=1.3.1 --yes
conda create --name plasmidEC_platon -c bioconda platon=1.6 --yes
conda create --name plasmidEC_rfplasmid -c bioconda rfplasmid=0.0.18 --yes
conda activate plasmidEC_rfplasmid
rfplasmid --initialize
conda deactivate
conda create --name plasmidEC_R r=4.1 --yes
conda activate plasmidEC_R
conda install -c bioconda bioconductor-biostrings=2.60.0 --yes
conda install -c conda-forge r-plyr=1.8.6 --yes
conda install -c conda-forge r-dplyr=1.0.7 --yes
conda deactivate
