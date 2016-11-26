#!/bin/bash

# Install LArSoft-v05_08_00_05
cd $WORKING_DIR
echo "Installing LArSoft-v05_08_00_05"

source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup uboonecode v05_08_00_05 -q e9:prof
mkdir LArSoft-v05_08_00_05
cd LArSoft-v05_08_00_05
mrb newDev
cd $WORKING_DIR
