#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Install deago
conda create -n deago-1.1.3
conda activate deago-1.1.3
conda install -c bioconda perl-app-cpanminus=1.7043
conda install -c bioconda perl-lwp-protocol-https=6.06 
conda install -c bioconda perl-bioperl=1.6.924
cpanm Dist::Zilla@5.048
conda install bioconductor-deseq2=1.34.0 bioconductor-topgo=2.46.0 r-devtools=2.4.3 pandoc=2.18 bioconductor-limma=3.50.1 r-reshape=0.8.9 r-ggrepel=0.9.1 r-ggpubr=0.4.0 r-proto=1.0.0 r-markdown=1.1 r-rmarkdown=2.14
wget https://github.com/vaofford/deago/archive/refs/tags/v1.1.3.tar.gz
wget https://github.com/vaofford/Bio-Deago/archive/refs/tags/v1.0.0.tar.gz
tar -xvf v1.0.0.tar.gz
R CMD INSTALL v1.1.3.tar.gz
cd Bio-Deago-1.0.0/
dzil authordeps --missing | cpanm
dzil listdeps --missing | cpanm 
dzil install
cd ..
rm v1.1.3.tar.gz
rm v1.0.0.tar.gz
rm -rf Bio-Deago-1.0.0
conda deactivate

set +eu
