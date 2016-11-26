#!/bin/bash

# Install LArSoft-v04_36_00_03
cd $WORKING_DIR
echo "Installing LArSoft-v04_36_00_03"

source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v04_36_00_03 -q e9:prof
mkdir LArSoft-v04_36_00_03
cd LArSoft-v04_36_00_03
mrb newDev
source $WORKING_DIR/LArSoft-v04_36_00_03/localProducts_larsoft_v04_36_00_03_e9_prof/setup

# Install myfiltermodule
echo "Installing the filter"
cd $MRB_SOURCE
mrb g https://github.com/loressa/myfiltermodule.git
cd myfiltermodule
git checkout v04_36_00_03
cd $MRB_BUILDDIR
mrbsetenv
mrb i
mrbslp
