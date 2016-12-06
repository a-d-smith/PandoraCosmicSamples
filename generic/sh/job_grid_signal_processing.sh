#!/usr/bin/env bash                                                                                                                       

source /grid/fermiapp/products/uboone/setup_uboone.sh 
setup uboonecode v05_08_00_05 -q e9:prof
export USRDIR=WORKING_DIR/generic/fcl
export INDIR=/pnfs/uboone/scratch/users/USER_NAME/PROJECT_NUANCE/detsim/IN_DIR
export OUTDIR=/pnfs/uboone/scratch/users/USER_NAME/PROJECT_NUANCE/sig/INDEX

ifdh cp ${INDIR}/prodgenie_bnb_nu_cosmic_uboone*.root my_file.root 
ifdh cp ${USRDIR}/my_signal_processing.fcl . 
lar -c my_signal_processing.fcl -n -1 -s my_file.root 
ifdh cp *.root ${OUTDIR}/.
