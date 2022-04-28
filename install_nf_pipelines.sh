#!/bin/bash

set -eu

# Script to download and install nextflow, assumes a user exists called software and that this scipt is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Install singularity as root - maybe extract to own script?
wget https://github.com/sylabs/singularity/releases/download/v3.9.8/singularity-ce_3.9.8-focal_amd64.deb
sudo dpkg -i singularity-ce_3.9.8-focal_amd64.debpipelines on server
rm singularity-ce_3.9.8-focal_amd64.deb

# Create a nextflow-pipelines environment with nextflow and nf-core 
conda create -n nextflow-pipelines nextflow=21.10.6
conda activate nextflow-pipelines
conda install nf-core

# Set up environment variables
cd ~
mkdir singularity
export NXF_SINGULARITY_CACHEDIR=/home/software/singularity

mkdir nf-pipelines
cd nf-pipelines

# Install pipelines from nf core
nf-core download --compress none --container singularity --revision 1.5 fetchngs
nf-core download --compress none --container singularity --revision 1.0.0 bactmap
nf-core download --compress none --container singularity --revision 3.6 rnaseq
nf-core download --compress none --container singularity --revision 1.1.0 scrnaseq
nf-core download --compress none --container singularity --revision 2.0.1 nanoseq
nf-core download --compress none --container singularity --revision 2.1.1 mag

# Install other nf pipelines
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/assembly/-/archive/2.1.2/assembly-2.1.2.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/mlst/-/archive/1.2/mlst-1.2.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/amr_prediction/-/archive/1.1/amr_prediction-1.1.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/roary/-/archive/1.1.4/roary-1.1.4.tar.gz

# No releases available
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/ariba.git
git clone https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/plasmidfinder.git

cd ..

# Install bespoke scripts for running nf pipelines 
git clone https://github.com/citiid-baker/nf_pipeline_scripts.git
cp *.sh /home/software/miniconda/envs/nextflow-pipelines/bin
