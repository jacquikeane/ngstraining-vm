#!/bin/bash

set -eu

# Script to initialise VM set up and should be run as root/sudo

apt-get install gcc
apt-get install make
apt-get install git

# Install singularity
wget https://github.com/sylabs/singularity/releases/download/v3.9.8/singularity-ce_3.9.8-focal_amd64.deb
dpkg -i singularity-ce_3.9.8-focal_amd64.deb
rm singularity-ce_3.9.8-focal_amd64.deb

set +eu
