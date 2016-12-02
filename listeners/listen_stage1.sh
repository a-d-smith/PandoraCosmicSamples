#!/bin/bash

if [ ! -f $WORKING_DIR/listeners/stage ]; then
  echo 0 >> $WORKING_DIR/listeners/stage
fi

# GENIE stage
if [ `cat $WORKING_DIR/listeners/stage` == 1 ]; then
  echo 'GENIE'
fi

# G4 + Filter Stage
if [ `cat $WORKING_DIR/listeners/stage` == 2 ]; then
  echo 'G4'
fi

# DetSim Stage
if [ `cat $WORKING_DIR/listeners/stage` == 3 ]; then
  echo 'DETSIM'
fi

sleep 1
source $WORKING_DIR/listeners/listen_stage1.sh
