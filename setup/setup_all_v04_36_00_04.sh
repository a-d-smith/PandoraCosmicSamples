#!/bin/bash

# Make sure that the user is running from the repo
if [ "`basename $(pwd)`" != "PandoraCosmicSamples" ]; then
  echo "Oops: You need to run this script from the directory \"PandoraCosmicSamples\""
  echo "      This is so I can setup your working area to be inside the repo you cloned from github!"
  echo ""
  echo "      You should be typing:"
  echo "      source setup/setup_all_v04_36_00_04.sh"
  echo ""
  return
fi

export USER_NAME=`whoami`
export WORKING_DIR=`pwd`
source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v04_36_00_03 -q e9:prof
source $WORKING_DIR/LArSoft-v04_36_00_03/localProducts_larsoft_v04_36_00_03_e9_prof/setup
cd $MRB_BUILDDIR
mrbslp
cd $WORKING_DIR
source setup/setup_grid.sh

