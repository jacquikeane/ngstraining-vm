#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Install qualifyr
conda create -n qualifyr-1.4.6 python=3.8
conda activate qualifyr-1.4.6 
wget https://gitlab.com/cgps/qualifyr/-/archive/1.4.6/qualifyr-1.4.6.tar.gz
tar -xf qualifyr-1.4.6.tar.gz
cd qualifyr-1.4.6/
python setup.py install
cd ..
rm qualifyr-1.4.6.tar.gz
rm -rf qualifyr-1.4.6
conda deactivate

set +eu
