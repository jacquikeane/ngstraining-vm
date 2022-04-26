#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software

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

conda create -n signalp-6.0 python
conda activate signalp-6.0 
conda install tqdm>4.46.1 matplotlib>3.3.2 numpy>1.19.2
pip install torch
pip install signalp-6-package
//copy the databases
conda deactivate

conda activate prokka 
conda install tqdm>4.46.1 matplotlib>3.3.2 numpy>1.19.2
pip install torch
pip install signalp-6-package/
//copy the databases
SIGNALP_DIR=$(python3 -c "import signalp; import os; print(os.path.dirname(signalp.__file__))" )
cp -r signalp-6-package/models/* $SIGNALP_DIR/model_weights/

conda deactivate

//Installs for plasmidEC                
conda env create --file=/home/software/src/plasmidEC-1.1/yml/plasmidEC_mlplasmids.yml
conda create --name plasmidEC_plascope -c bioconda/label/cf201901 plascope=1.3.1 --yes
conda create --name plasmidEC_platon -c bioconda platon=1.6 --yes
conda create --name plasmidEC_rfplasmid -c bioconda rfplasmid=0.0.18 --yes
conda activate plasmidEC_rfplasmid
rfplasmid --initialize
conda deactivate
conda create --name plasmidEC_R r=4.1 --yes
conda activate plasmidEC_R
conda install -c bioconda bioconductor-biostrings=2.60.0 --yes
conda install -c conda-forge r-plyr=1.8.6 --yes
conda install -c conda-forge r-dplyr=1.0.7 --yes
conda deactivate

//checkout the deago repos
wget https://github.com/vaofford/deago/archive/refs/tags/v1.1.3.tar.gz
tar -xvf v1.1.3.tar.gz
rm v1.1.3.tar.gz
wget https://github.com/vaofford/Bio-Deago/archive/refs/tags/v1.0.0.tar.gz
tar -xvf v1.1.3.tar.gz
rm v1.1.3.tar.gz
conda create -c dan_blanchard -n deago-1.1.3 perl-dist-zilla=5.013
conda activate deago-1.1.3
conda install bioconductor-deseq2=1.34.0 bioconductor-topgo=2.46.0 r-devtools=2.4.3 pandoc=2.18 perl-app-cpanminus=1.7039 
cpanm Dist::Zilla
cd Bio-Deago-1.0.0/
dzil authordeps --missing | cpanm
dzil listdeps --missing | cpanm 
conda deactivate

//Install qualifyr
conda create -n qualifyr-1.4.6 python=3.8
conada activate qualifyr-1.4.6 
git clone https://gitlab.com/cgps/qualifyr.git
cd qualifyr
git checkout 4d61a4d9
python setup.py install
cd ..
conda deactivate

echo "Don't forget to manually install signalp in the signalp and the prokka environments!!"

set +eu
