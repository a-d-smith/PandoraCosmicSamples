#!/bin/bash

if [ $# != 1 ]; then
  echo "Error: Please pass the name of the project as an argument"
  return
fi

project=$1

if [ ! -f $WORKING_DIR/listeners/stage ]; then
  echo 0 >> $WORKING_DIR/listeners/stage
  echo 0 >> $WORKING_DIR/listeners/action
  echo 1001 >> $WORKING_DIR/listeners/nuance
fi

stage=`cat $WORKING_DIR/listeners/stage`
action=`cat $WORKING_DIR/listeners/action`
nuance=`cat $WORKING_DIR/listeners/nuance`

# Clear the terminal
tput cup 0 0 
tput ed 

echo 'Project: '$project
echo '================================================================================'

# GENIE stage
echo '# Stage: GENIE'        
if [ $stage == 1 ]; then
  if [ $action == 0 ]; then
    # action = 0 -> Idle
    echo 'Status: Idle'
  elif [ $action == 1 ]; then
    # action = 1 -> Submit
    echo 'Status: Submitting'
  fi
else
  echo 'Status: Waiting...'
fi

# G4 + Filter Stage
echo '# Stage: G4 + Filter'        
if [ $stage == 2 ]; then
  echo 'G4'
else
  echo 'Status: Waiting...'
fi

# DetSim Stage
if [ $stage == 3 ]; then
  echo 'DETSIM'
else
  echo 'Status: Waiting...'
fi

sleep 1
source $WORKING_DIR/listeners/listen_stage1.sh
