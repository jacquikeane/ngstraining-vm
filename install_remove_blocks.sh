#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

# Create remove_blocks profile and also add it to the snp-phylogeny environment

wget https://github.com/sanger-pathogens/remove_blocks_from_aln/archive/refs/tags/0.1.tar.gz
tar -xvf 0.1.tar.gz
cd remove_blocks_from_aln-0.1

conda create -n remove-blocks-0.1 python=2.7
conda activate remove-blocks-0.1
python setup.py test
python setup.py install
conda deactivate 
cd ..
rm 0.1.tar.gz
rm -rf remove_blocks_from_aln-0.1

set +eu
