#!/bin/bash

set -eu

# Script assumes a user exists called software and that the source for signalp exists and that the script is run as user software

source $MINICONDA/etc/profile.d/conda.sh

# Install signalp and add it to the prokka environment

conda create -n signalp-6.0 python
conda activate signalp-6.0 
conda install tqdm>4.46.1 matplotlib>3.3.2 numpy>1.19.2
pip install torch
pip install signalp-6-package
# copy the databases
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

set +eu
