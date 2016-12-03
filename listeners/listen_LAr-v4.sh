#!/bin/bash

if [ $# -ne 1 ]; then
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
totEvents=`cat $WORKING_DIR/projects/$project/$nuance/requestedEvents`

# Clear the terminal
#tput cup 0 0 
#tput ed 

echo 'Project: '$project
echo '================================================================================'
echo 'Nuance Code: '$nuance
echo 'Requested Events:'$totEvents
echo ''
# GENIE stage
echo '# Stage: GENIE'        
if [ $stage == 1 ]; then
  if [ $action == 0 ]; then
    # action = 0 -> Idle
    echo 'Status: Idle'
  elif [ $action == 1 ]; then
    # action = 1 -> Submit
    genEvents=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f1 -d' '`
    genJobs=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f2 -d' '`
    echo 'Status: Submitting '$genEvents' over '$genJobs' jobs'
    source $WORKING_DIR/helpers/job_submit_gen.sh $project $nuance
    echo 2 >> $WORKING_DIR/listeners/action
  elif [ $action == 2 ]; then
    # action = 2 -> Wait for jobs to finish
    echo 'Status: Waiting for jobs to finish'
    # Count the number of root files we have
    genJobsDone=`find '/pnfs/uboone/scratch/users/'$USER_NAME'/'$project'_'$nuance'/*/prodgenie*.root' -type f | wc -l`
    genJobs=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f2 -d' '`
    echo $genJobsDone' jobs complete of a total '$genJobs
    if [ $genJobsDone == $genJobs ]; then
      echo 3 >> $WORKING_DIR/listeners/action 
    fi
  elif [ $action == 3 ]; then
    # action = 3 -> Check jobs
    echo 'Status: Checking jobs for good events'
    source $WORKING_DIR/helpers/job_check_gen.sh $project $nuance
    echo 4 >> $WORKING_DIR/listeners/action
  elif [ $action == 4]; then
    # action = 4 -> Prepare XML file for next stage
    echo 'Status: Preparing for G4 + Filter'
    g4Events=0
    while read line; do
      n=`echo $line | cut -f2 -d' '`
      g4Events=$(($g4Events + $n))
    done < '/pnfs/uboone/scratch/users/'$USER_NAME'/'$project'_'$nuance'/events.list'
    g4Jobs=`bc -l <<< $g4Events'/10'`
    g4Jobs=`printf '%.*f' 0 $g4Jobs`
    echo $g4Events >> $WORKING_DIR/projects/$project/$nuance/g4Events
    echo $g4Jobs > $WORKING_DIR/projects/$project/$nuance/g4Events

    sed -i -e 's,G4_EVENTS,'$g4Events',g' $WORKING_DIR'/projects/'$project'/'$nuance'/prod_chain_'$nuance'.xml'
    sed -i -e 's,G4_JOBS,'$g4Jobs',g' $WORKING_DIR'/projects/'$project'/'$nuance'/prod_chain_'$nuance'.xml'

    echo 0 >> $WORKING_DIR/listeners/action
    echo 2 >> $WORKING_DIR/listeners/stage
  fi
elif [ $stage -gt 1 ]; then
  genEvents=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f1 -d' '`
  genJobs=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f2 -d' '`
  g4Events=`cat $WORKING_DIR/projects/$project/$nuance/g4Events | cut -f1 -d' '`
  echo 'Status: Complete'
  echo 'Ran '$genEvents' events over '$genJobs' jobs, and '$g4Events' passed'
else
  echo 'Status: Waiting...'
fi

echo ''
# G4 + Filter Stage
echo '# Stage: G4 + Filter'        
if [ $stage == 2 ]; then
  echo 'G4'
else
  echo 'Status: Waiting...'
fi

echo ''
# DetSim Stage
if [ $stage == 3 ]; then
  echo 'DETSIM'
else
  echo 'Status: Waiting...'
fi

sleep 1
source $WORKING_DIR/listeners/listen_LAr-v4.sh $project 
