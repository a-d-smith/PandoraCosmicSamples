#!/bin/bash

# Make sure that the user is running from the repo
if [ "`basename $(pwd)`" != "PandoraCosmicSamples" ]; then
  echo "Oops: You need to run this script from the directory \"PandoraCosmicSamples\""
  echo "      This is so I can setup your working area to be inside the repo you cloned from github!"
  echo ""
  echo "      You should be typing:"
  echo "      source setup/setup_all_v05_08_00_05.sh"
  echo ""
  return
fi

export USER_NAME=`whoami`
export WORKING_DIR=`pwd`
source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v05_08_00_05 -q e9:prof
source $WORKING_DIR/LArSoft-v05_08_00_05/localProducts_larsoft_v05_08_00_e9_prof/setup
cd $MRB_BUILDDIR
mrbslp
cd $WORKING_DIR
source setup/setup_grid.sh

