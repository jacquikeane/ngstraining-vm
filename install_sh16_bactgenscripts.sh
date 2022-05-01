#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Install bactgen/sh16 scripts
conda create -n sh16-scripts-0.3 python=2.7
conda activate sh16-scripts-0.3
wget https://github.com/sanger-pathogens/bact-gen-scripts/archive/refs/tags/v0.3.tar.gz
tar -xf v0.3.tar.gz
cd bact-gen-scripts-0.3
pip install $(grep numpy ./pip/requirements.txt)
pip install $(grep fisher ./pip/requirements.txt)
pip install -r ./pip/requirements.txt
conda install samtools=1.6
conda install beast=1.8.4
conda install gatk=3.7.0
conda install picard=1.126
conda install bwa=0.7.17
conda install raxml=8.2.9
conda install paml=4.9
conda install smalt=0.7.6
cp *.py /home/software/miniconda/envs/sh16-scripts-0.3/bin
cp -r modules /home/software/miniconda/envs/sh16-scripts-0.3/bin
cd ..
rm v0.3.tar.gz
rm -rf bact-gen-scripts-0.3
wget ftp://ftp.sanger.ac.uk/pub/resources/software/ssaha2/ssaha2_v2.5.5_x86_64.tgz
tar -xf ssaha2_v2.5.5_x86_64.tgz
cd ssaha2_v2.5.5_x86_64/
cp ssaha* /home/software/miniconda/envs/sh16-scripts-0.3/bin
cd ..
rm ssaha2_v2.5.5_x86_64.tgz
rm -rf ssaha2_v2.5.5_x86_64
conda deactivate

set +eu
