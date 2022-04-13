#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run in the checkout directory

# Set up variables and add miniconda location to PATH
export MINICONDA="/home/software/miniconda"
export MINICONDA_BIN_LOCATION="$MINICONDA/bin"
export PATH="$MINICONDA_BIN_LOCATION:$PATH"

# Download and install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $MINICONDA

# Set conda for autoinstalls and update conda
conda config --set always_yes yes --set changeps1 no
conda update -n base -c defaults conda

# Useful for debugging any issues with conda
conda info -a

# Set the conda channels
conda config --add channels defaults
conda config --add channels r
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority true

# Initialise conda
conda init bash

# Install software using miniconda
echo "Reading bioconda software list!"
while read -r line;
do
    echo "Installing ${line}"
    # Split line on comma into environment and software list
    IFS=',' read -a myarray <<<  $line
    environment=${myarray[0]}
    software=${myarray[1]}
    # Create a new conda environment with the software
    conda create -n $environment $software
done < software.txt

# Fix for prokka
conda activate prokka-1.14.6
conda install -y perl-app-cpanminus
cpanm Bio::SearchIO::hmmer --force
echo "Don't forget to manually install signalp for prokka"

# Create bespoke ont profile
conda create -n ont-pipeline
conda activate ont-pipeline
conda install medaka=1.5
conda install busco=5.3.0
conda install assembly-stats=1.0.1 bwa=0.7.17 flye=2.9 filtlong=0.2.1 nanostat=1.6 nanofilt=2.8.0 nanoplot=1.39 nanopolish=0.13.2 pilon=1.24 porechop=0.2.4 seqtk=1.3 trimmomatic=0.39 unicycler=0.5
conda deactivate

# Create remove_blocks profile and add it to the snp-phylogeny environment
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

echo "!!! Don't forget to set a permanent global variable on the server MINICONDA=$MINICONDA !!!"

set +eu
