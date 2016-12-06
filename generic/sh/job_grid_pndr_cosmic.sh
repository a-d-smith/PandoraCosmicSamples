#!/usr/bin/env bash                                                                                                                       

source /grid/fermiapp/products/uboone/setup_uboone.sh 
setup uboonecode v05_08_00_05 -q e9:prof
export USRDIR=/uboone/app/users/asmith/gridsub/LArSoft-v05_08_00_05 
export INDIR=/pnfs/uboone/scratch/users/asmith/my_prod_chain_cosmic_res/detsim/15053962_0
export OUTDIR=/pnfs/uboone/scratch/users/asmith/pndrFiles/test 

ifdh cp ${INDIR}/prodgenie_bnb_nu_cosmic_uboone*.root my_file.root 
ifdh cp ${USRDIR}/my_pandora_writer_cosmic.fcl . 
ifdh cp ${USRDIR}/MyPandoraSettings_Write_cosmic1.xml . 
ifdh cp ${USRDIR}/MyPandoraSettings_Write_cosmic2.xml . 
lar -c my_pandora_writer_cosmic.fcl -n 1 -s my_file.root 
ifdh cp Pandora_Events_cosmic1.pndr ${OUTDIR}/Pandora_Events_cosmic_1.pndr
ifdh cp Pandora_Events_cosmic2.pndr ${OUTDIR}/Pandora_Events_cosmic_2.pndr
