#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

# Create remove_blocks profile and also add it to the snp-phylogeny environment

git clone https://github.com/sanger-pathogens/remove_blocks_from_aln.git
cd remove_blocks_from_aln

conda create -n remove-blocks-0.1 python=2.7
conda activate remove-blocks-0.1
python setup.py test
python setup.py install
conda deactivate 

conda activate snp-phylogeny
python setup.py test
python setup.py install
conda deactivate
cd ..

set +eu
