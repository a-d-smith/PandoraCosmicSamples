#!/usr/bin/env bash                                                                                                                       

source /grid/fermiapp/products/uboone/setup_uboone.sh 
setup uboonecode v06_15_01 -q e10:prof

export WORKINGDIR=WORKING_DIR
export USRDIR=WORKING_DIR/projects/PROJECT/NUANCE
export INDIR=/pnfs/uboone/scratch/users/USER_NAME/PROJECT_NUANCE/sig/INDEX
export OUTDIR=/pnfs/uboone/scratch/users/USER_NAME/PROJECT_NUANCE/pndr/INDEX

ifdh cp ${INDIR}/output_signal_processing.root my_file.root 
ifdh cp ${WORKINGDIR}/generic/fcl/my_pandora_writer.fcl my_pandora_writer.fcl 
ifdh cp ${WORKINGDIR}/generic/xml/MyPandoraSettings_Write_cosmic1.xml MyPandoraSettings_Write_cosmic1.xml
ifdh cp ${WORKINGDIR}/generic/xml/MyPandoraSettings_Write_cosmic2.xml MyPandoraSettings_Write_cosmic2.xml 

lar -c my_pandora_writer.fcl -n -1 -s my_file.root

ifdh cp Pandora_Events_cosmic1.pndr ${OUTDIR}/bnb_cosmic-filtered_NUANCE-pre_removal-INDEX.pndr
ifdh cp Pandora_Events_cosmic2.pndr ${OUTDIR}/bnb_cosmic-filtered_NUANCE-post_removal-INDEX.pndr
