#!/bin/bash

set -eu

# Script to download and install nextflow, assumes a user exists called software and that this scipt is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Install singularity as root - maybe extract to own script?
#wget https://github.com/sylabs/singularity/releases/download/v3.9.8/singularity-ce_3.9.8-focal_amd64.deb
#sudo dpkg -i singularity-ce_3.9.8-focal_amd64.deb
#rm singularity-ce_3.9.8-focal_amd64.deb

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

# Install other nf pipelines from cgps
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/assembly/-/archive/2.1.2/assembly-2.1.2.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/mlst/-/archive/1.2/mlst-1.2.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/dsl2/pipelines/amr_prediction/-/archive/1.1/amr_prediction-1.1.tar.gz
wget https://gitlab.com/cgps/ghru/pipelines/roary/-/archive/1.1.4/roary-1.1.4.tar.gz

tar -xf assembly-2.1.2.tar.gz
tar -xf mlst-1.2.tar.gz
tar -xf amr_prediction-1.1.tar.gz
tar -xf roary-1.1.4.tar.gz
rm assembly-2.1.2.tar.gz
rm mlst-1.2.tar.gz
rm amr_prediction-1.1.tar.gz
rm roary-1.1.4.tar.gz


cd ..

echo "!!! Don't forget to get the singularity containers for the cgps/ghru pipelines"

# Install bespoke scripts for running nf pipelines 
git clone https://github.com/jacquikeane/nf_pipeline_scripts.git
cd nf_pipeline_scripts
cp *.sh /home/software/minicondaconda/envs/nextflow-pipelines/bin
cd ..

conda deactivate
