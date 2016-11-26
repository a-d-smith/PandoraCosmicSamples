#!/bin/bash

export USER_NAME=`whoami`
export WORKING_DIR=/uboone/app/users/$USER_NAME/gridsub
source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v04_36_00_03 -q e9:prof
source $WORKING_DIR/LArSoft-v04_36_00_03/localProducts_larsoft_v04_36_00_03_e9_prof/setup
cd $MRB_BUILDDIR
mrbslp
cd $WORKING_DIR/LArSoft-v04_36_00_03
source ../setup_grid.sh

