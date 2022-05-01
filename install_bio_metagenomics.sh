#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Install Bio::Metagenomics
conda create -n bio-metagenomics-0.1.1
conda activate bio-metagenomics-0.1.1
conda install -c bioconda perl-app-cpanminus=1.7043
conda install -c bioconda perl-lwp-protocol-https=6.06 
conda install -c bioconda perl-bioperl=1.6.924
cpanm Dist::Zilla@5.048
conda install kraken=1.1
wget https://github.com/sanger-pathogens/Bio-Metagenomics/archive/refs/tags/v0.1.1.tar.gz
tar -xf v0.1.1.tar.gz
cd Bio-Metagenomics-0.1.1
dzil authordeps --missing | cpanm
dzil listdeps --missing | cpanm
mkdir fake_bin
for x in kraken kraken-build kraken-report merge_metaphlan_tables.py metaphlan_hclust_heatmap.py; do touch fake_bin/$x; done
chmod -R 755 fake_bin
PATH=$(pwd)/fake_bin:$PATH
dzil install
metaphlan_heatmap=$(which metagm_make_metaphlan_heatmap)
metaphlan_hclust=$(which metaphlan_hclust_heatmap.py)
chmod 600 $metaphlan_heatmap $metaphlan_hclust
conda install python=3.8
conda install pyfastaq=3.17
cd ..
rm -rf Bio-Metagenomics-0.1.1
rm v0.1.1.tar.gz
conda deactivate

set +eu
