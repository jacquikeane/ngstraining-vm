#!/bin/bash

set -eu

# Script to download and install nextflow, assumes a user exists called software and that this scipt is run as user software

# Install singularity as root
wget https://github.com/sylabs/singularity/releases/download/v3.9.8/singularity-ce_3.9.8-focal_amd64.deb
sudo dpkg -i singularity-ce_3.9.8-focal_amd64.debpipelines on server
rm singularity-ce_3.9.8-focal_amd64.deb

# Activate nextflow environment
source $MINICONDA/etc/profile.d/conda.sh
conda activate nextflow-21.10.6

# Install nf-core
conda install nf-core

# Set up environment variables
mkdir singularity
export NXF_SINGULARITY_CACHEDIR=/home/software/singularity

mkdir nf-pipelines
cd nf-pipelines

# Install pipelines from nf core
nf-core download --container singularity fetchngs
nf-core download --container singularity bactmap
nf-core download --container singularity bacass
nf-core download --container singularity rnaseq
nf-core download --container singularity scrnaseq
nf-core download --container singularity nanoseq

# Install other nf pipelines
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/assembly/-/archive/2.1.2/assembly-2.1.2.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/snp_phylogeny/-/archive/1.2.2/snp_phylogeny-1.2.2.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/roary/-/archive/1.1.4/roary-1.1.4.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/mlst/-/archive/1.2/mlst-1.2.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/amr_prediction/-/archive/1.1/amr_prediction-1.1.tar.gz

# No releases available
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/ariba.git
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/plasmidfinder.git

cd ..

# Install bespoke scripts for running nf pipelines 
git clone https://github.com/citiid-baker/nf_pipeline_scripts.git
