#!/bin/bash

set -eu

# Script assumes a user exists called software and that the script is run as user software and a directory called /data/dbs exists

source $MINICONDA/etc/profile.d/conda.sh

# get the date
CURRENT_DATE=`date +"%Y-%m-%d"`

cd /data/dbs

# ariba
mkdir ariba
mkdir ariba/${CURRENT_DATE}
cd ariba/${CURRENT_DATE}

conda activate ariba-2.14.6
//make a for loop
for i in argannot card megares ncbi plasmidfinder refinder srst2_argannot vfdb_core vfdb_full virulencefinder
ariba getref argannot argannot
ariba prepareref -f argannot.fa -m argannot.tsv argannot
ariba getref card card
ariba prepareref -f card.fa -m card.tsv card
ariba getref megares megares
ariba prepareref -f megares.fa -m megares.tsv megares
#ariba getref ncbi ncbi
#ariba prepareref -f ncbi.fa -m ncbi.tsv ncbi
ariba getref plasmidfinder plasmidfinder
ariba prepareref -f plasmidfinder.fa -m plasmidfinder.tsv plasmidfinder
ariba getref resfinder resfinder
ariba prepareref -f resfinder.fa -m resfinder.tsv resfinder
ariba getref srst2_argannot srst2_argannot
ariba prepareref -f srst2_argannot.fa -m srst2_argannot.tsv srst2_argannot
ariba getref vfdb_core vfdb_core
ariba prepareref -f vfdb_core.fa -m vfdb_core.tsv vfdb_core
ariba getref vfdb_full vfdb_full
ariba prepareref -f vfdb_full.fa -m vfdb_full.tsv vfdb_full
ariba getref virulencefinder virulencefinder
ariba prepareref -f virulencefinder.fa -m virulencefinder.tsv virulencefinder
conda deactivate
cd ../..

# argannot

# blast
mkdir blast/v5
conda activate blast-2.12
for i in 16S_ribosomal_RNA.tar.gz Betacoronavirus human_genome mouse_genome nr nt swissprot ref_euk_rep_genomes ref_prok_rep_genomes refseq_select_rna refseq_select_prot refseq_protein refseq_rna
update_blastdb.pl $i --blastdb_version 5
tar -xf $i* -C $i
conda deactivate
cd ../..

# card

# greengenes

# kraken2
mkdir kraken2
cd kraken2/
for i in k2_viral_20210517.tar.gz k2_standard_16gb_20210517.tar.gz k2_standard_16gb_20210517 k2_pluspf_16gb_20210517 16S_Greengenes13.5_20200326 16S_RDP11.5_20200326 16S_Silva132_20200326 16S_Silva138_20200326
wget https://genome-idx.s3.amazonaws.com/kraken/k2_viral_20210517.tar.gz
mkdir k2_standard_16gb_20210517
tar -xf k2_viral_20210517.tar.gz -C k2_standard_16gb_20210517
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_16gb_20210517.tar.gz
mkdir k2_standard_16gb_20210517
tar -xf k2_standard_16gb_20210517.tar.gz -C k2_standard_16gb_20210517
wget https://genome-idx.s3.amazonaws.com/kraken/k2_pluspf_16gb_20210517.tar.gz.tar.gz
mkdir k2_pluspf_16gb_20210517
tar -xf k2_pluspf_16gb_20210517.tar.gz -C k2_pluspf_16gb_20210517
wget https://genome-idx.s3.amazonaws.com/kraken/16S_Greengenes13.5_20200326.tgz
mkdir 16S_Greengenes13.5_20200326
tar -xf 16S_Greengenes13.5_20200326.tgz -C 16S_Greengenes13.5_20200326
wget https://genome-idx.s3.amazonaws.com/kraken/16S_RDP11.5_20200326.tgz
mkdir 16S_RDP11.5_20200326
tar -xf 16S_RDP11.5_20200326.tgz -C 16S_RDP11.5_20200326
wget https://genome-idx.s3.amazonaws.com/kraken/16S_Silva132_20200326.tgz
mkdir 16S_Silva132_20200326
tar -xf 16S_Silva132_20200326.tgz -C 16S_Silva132_20200326
wget https://genome-idx.s3.amazonaws.com/kraken/16S_Silva138_20200326.tgz
mkdir 16S_Silva138_20200326
tar -xf 16S_Silva138_20200326.tgz -C 16S_Silva138_20200326
cd ..

# megares

# mothur

# plasmidfinder

# resfinder

# RDP

# silva

# virulencefinder
