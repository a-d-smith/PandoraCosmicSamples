#!/bin/bash

# Make sure that the user is running from the repo
if [ "`basename $(pwd)`" != "PandoraCosmicSamples" ]; then
  echo "Oops: You need to run this script from the directory \"PandoraCosmicSamples\""
  echo "      This is so I can setup your working area to be inside the repo you cloned from github!"
  echo ""
  echo "      You should be typing:"
  echo "      source install/install_dependencies_part2.sh"
  echo ""
  return
fi

export WORKING_DIR=`pwd`

# Install LArSoft-v05_08_00_05
cd $WORKING_DIR
echo "Installing LArSoft-v05_08_00_05"

source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v05_08_00_05 -q e9:prof
mkdir LArSoft-v05_08_00_05
cd LArSoft-v05_08_00_05
mrb newDev
cd $WORKING_DIR
