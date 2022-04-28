#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software
https://github.com/citiid-baker/bakersrv1/blob/main/install_conda_software.sh
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

# Install signalp and add it to the prokka environment
conda create -n signalp-6.0 python
conda activate signalp-6.0 
conda install tqdm>4.46.1 matplotlib>3.3.2 numpy>1.19.2
pip install torch
pip install signalp-6-package
#copy the databases
SIGNALP_DIR=$(python3 -c "import signalp; import os; print(os.path.dirname(signalp.__file__))" )
cp -r signalp-6-package/models/* $SIGNALP_DIR/model_weights/
conda deactivate

conda activate prokka 
conda install tqdm>4.46.1 matplotlib>3.3.2 numpy>1.19.2
pip install torch
pip install signalp-6-package/
#copy the databases
SIGNALP_DIR=$(python3 -c "import signalp; import os; print(os.path.dirname(signalp.__file__))" )
cp -r signalp-6-package/models/* $SIGNALP_DIR/model_weights/
conda deactivate

# Installs for plasmidEC                
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

# Install Bio::Metagenomics
conda create -n metagm-0.1.1
conda activate metagm-0.1.1
conda install -c bioconda perl-app-cpanminus=1.7043
conda install -c bioconda perl-lwp-protocol-https=6.06 
conda install -c bioconda perl-net-ssleay=1.84 
conda install -c bioconda perl-bioperl=1.6.924
cpanm Dist::Zilla@5.048
conda install kraken
conda install pyfastaq
wget/git clone https://github.com/sanger-pathogens/Bio-Metagenomics.git
cd Bio-Metagenomics
git checkout bbcc2ca
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
conda install python=3
conda install pyfastaq
conda deactivate

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
