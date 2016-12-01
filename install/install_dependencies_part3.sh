#!/bin/bash

# Make sure that the user is running from the repo
if [ "`basename $(pwd)`" != "PandoraCosmicSamples" ]; then
  echo "Oops: You need to run this script from the directory \"PandoraCosmicSamples\""
  echo "      This is so I can setup your working area to be inside the repo you cloned from github!"
  echo ""
  echo "      You should be typing:"
  echo "      source install/install_dependencies_part3.sh"
  echo ""
  return
fi

export WORKING_DIR=`pwd`

# Install LArSoftv-06_15_01
cd $WORKING_DIR
echo "Installing LArSoft-v06_15_01"

source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v06_15_01 -q e10:prof
mkdir LArSoft-v06_15_01
cd LArSoft-v06_15_01
mrb newDev
cd $WORKING_DIR
