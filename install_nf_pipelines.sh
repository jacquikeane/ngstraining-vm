#!/bin/bash

set -eu

# Script to download and install nextflow oipelines on server

# Activate nextflow environment
source $MINICONDA/etc/profile.d/conda.sh
conda activate nextflow

# Set up environment variables

# Install pipelines from nf core
nf-core download --container singularity fetchngs
nf-core download --container singularity bactmap
nf-core download --container singularity bacass
nf-core download --container singularity rnaseq
nf-core download --container singularity scrnaseq
nf-core download --container singularity nanoseq

# Install other nf pipelines
cd XXX
//Maybe change the git clone to fetch specific releases of pipelines
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/assembly.git
git clone https://gitlab.com/cgps/ghru/pipelines/snp_phylogeny.git
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/mlst.git
git clone https://gitlab.com/cgps/ghru/pipelines/roary.git
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/ariba.git
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/amr_prediction.git
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/plasmidfinder.git

# Take a checkout of nf_pipeline scripts
git clone https://github.com/citiid-baker/nf_pipeline_scripts.git
