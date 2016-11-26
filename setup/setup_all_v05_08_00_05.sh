#!/bin/bash

export USER_NAME=`whoami`
export WORKING_DIR=/uboone/app/users/$USER_NAME/gridsub
source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v05_08_00_05 -q e9:prof
source $WORKING_DIR/LArSoft-v05_08_00_05/localProducts_larsoft_v05_08_00_e9_prof/setup
cd $MRB_BUILDDIR
mrbslp
cd $WORKING_DIR/LArSoft-v05_08_00_05
source ../setup_grid.sh



