#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Error: Please pass the name of the project as an argument"
  return
fi

project=$1

if [ ! -f $WORKING_DIR/listeners/stage ]; then
  echo 0 > $WORKING_DIR/listeners/stage
  echo 0 > $WORKING_DIR/listeners/action
  echo 1001 > $WORKING_DIR/listeners/nuance
fi

stage=`cat $WORKING_DIR/listeners/stage`
action=`cat $WORKING_DIR/listeners/action`
nuance=`cat $WORKING_DIR/listeners/nuance`
totEvents=`cat $WORKING_DIR/projects/$project/$nuance/requestedEvents`

# Clear the terminal
# tput cup 0 0 
# tput ed 

echo 'Project: '$project
echo '================================================================================'
echo 'Nuance Code: '$nuance
echo 'Requested Events: '$totEvents
echo ''
# GENIE stage
echo '# Stage: GENIE'        
if [ $stage == 1 ]; then
  if [ $action == 0 ]; then
    # action = 0 -> Idle
    echo 'Status: Idle'
  elif [ $action == 1 ]; then
    # action = 1 -> Submit
    genEvents=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f1 -d$'\n'`
    genJobs=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f2 -d$'\n'`
    echo 'Status: Submitting '$genEvents' events over '$genJobs' jobs'
    source $WORKING_DIR/helpers/job_submit_gen.sh $project $nuance
    echo 2 > $WORKING_DIR/listeners/action
  elif [ $action == 2 ]; then
    # action = 2 -> Wait for jobs to finish
    echo 'Status: Waiting for jobs to finish'
    # Count the number of root files we have
    find /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/*/lar.stat -type f > $WORKING_DIR/projects/$project/$nuance/genStat
    genJobsDone=0
    genJobsGood=0
    while read line; do
      if [ `cat $line` == 0 ]; then
        genJobsGood=$(($genJobsGood + 1))  
      fi
      genJobsDone=$(($genJobsDone + 1))  
    done < $WORKING_DIR/projects/$project/$nuance/genStat
    genJobs=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f2 -d$'\n'`
    echo $genJobsDone' jobs complete of a total '$genJobs'. '$genJobsGood' were successful.'
    if [ $genJobsDone == $genJobs ]; then
      echo 3 > $WORKING_DIR/listeners/action 
    fi
  elif [ $action == 3 ]; then
    # action = 3 -> Check jobs
    echo 'Status: Checking jobs for good events'
    source $WORKING_DIR/helpers/job_check_gen.sh $project $nuance
    echo 4 > $WORKING_DIR/listeners/action
  elif [ $action == 4 ]; then
    # action = 4 -> Prepare XML file for next stage
    echo 'Status: Preparing for G4 + Filter'
    g4Events=0
    while read line; do
      n=`echo $line | cut -f2 -d' '`
      g4Events=$(($g4Events + $n))
    done < '/pnfs/uboone/scratch/users/'$USER_NAME'/'$project'_'$nuance'/events.list'
    g4Jobs=`bc -l <<< $g4Events'/10'`
    g4Jobs=`printf '%.*f' 0 $g4Jobs`
    echo $g4Events > $WORKING_DIR/projects/$project/$nuance/g4Events
    echo $g4Jobs >> $WORKING_DIR/projects/$project/$nuance/g4Events

    sed -i '/<stage name="g4">/a <numevents>'$g4Events'</numevents> \n <numjobs>'$g4Jobs'</numjobs>' $WORKING_DIR'/projects/'$project'/'$nuance'/prod_chain_'$nuance'.xml'

    echo 1 > $WORKING_DIR/listeners/action
    echo 2 > $WORKING_DIR/listeners/stage
  fi
elif [ $stage -gt 1 ]; then
  genEvents=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f1 -d$'\n'`
  genJobs=`cat $WORKING_DIR/projects/$project/$nuance/genEvents | cut -f2 -d$'\n'`
  g4Events=`cat $WORKING_DIR/projects/$project/$nuance/g4Events | cut -f1 -d$'\n'`
  echo 'Status: Complete'
  echo 'Ran '$genEvents' events over '$genJobs' jobs, and '$g4Events' passed'
else
  echo 'Status: Waiting...'
fi





echo ''
# G4 + Filter Stage
echo '# Stage: G4 + Filter'        
if [ $stage == 2 ]; then
  if [ $action == 0 ]; then
    # action = 0 -> Idle
    echo 'Status: Idle'
  elif [ $action == 1 ]; then
    # action = 1 -> Submit
    g4Events=`cat $WORKING_DIR/projects/$project/$nuance/g4Events | cut -f1 -d$'\n'`
    g4Jobs=`cat $WORKING_DIR/projects/$project/$nuance/g4Events | cut -f2 -d$'\n'`
    echo 'Status: Submitting '$g4Events' events over '$g4Jobs' jobs'
    source $WORKING_DIR/helpers/job_submit_g4.sh $project $nuance
    echo 2 > $WORKING_DIR/listeners/action
  elif [ $action == 2 ]; then
    # action = 2 -> Wait for jobs to finish
    echo 'Status: Waiting for jobs to finish'
    # Count the number of root files we have
    find /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/g4/*/lar.stat -type f > $WORKING_DIR/projects/$project/$nuance/g4Stat
    g4JobsDone=0
    g4JobsGood=0
    while read line; do
      if [ `cat $line` == 0 ]; then
        g4JobsGood=$(($g4JobsGood + 1))  
      fi
      g4JobsDone=$(($g4JobsDone + 1))  
    done < $WORKING_DIR/projects/$project/$nuance/g4Stat
    g4Jobs=`cat $WORKING_DIR/projects/$project/$nuance/g4Events | cut -f2 -d$'\n'`
    echo $g4JobsDone' jobs complete of a total '$g4Jobs'. '$g4JobsGood' were successful.'
    if [ $g4JobsDone == $g4Jobs ]; then
      echo 3 > $WORKING_DIR/listeners/action 
    fi
  elif [ $action == 3 ]; then
    # action = 3 -> Check jobs
    echo 'Status: Checking jobs for good events'
    source $WORKING_DIR/helpers/job_check_g4.sh $project $nuance
    echo 4 > $WORKING_DIR/listeners/action
  elif [ $action == 4 ]; then
    # action = 4 -> Prepare XML file for next stage
    echo 'Status: Preparing for Detsim'
    detsimEvents=0
    while read line; do
      n=`echo $line | cut -f2 -d' '`
      detsimEvents=$(($detsimEvents + $n))
    done < '/pnfs/uboone/scratch/users/'$USER_NAME'/'$project'_'$nuance'/g4/events.list'
    detsimJobs=1
    #detsimJobs=`bc -l <<< $detsimEvents'/10'`
    #detsimJobs=`printf '%.*f' 0 $detsimJobs`
    echo $detsimEvents > $WORKING_DIR/projects/$project/$nuance/detsimEvents
    echo $detsimJobs >> $WORKING_DIR/projects/$project/$nuance/detsimEvents

    sed -i '/<stage name="detsim">/a <numevents>'$detsimEvents'</numevents> \n <numjobs>'$detsimJobs'</numjobs>' $WORKING_DIR'/projects/'$project'/'$nuance'/prod_chain_'$nuance'.xml'

    echo 1 > $WORKING_DIR/listeners/action
    echo 3 > $WORKING_DIR/listeners/stage
  fi
elif [ $stage -gt 1 ]; then
  g4Events=`cat $WORKING_DIR/projects/$project/$nuance/g4Events | cut -f1 -d$'\n'`
  g4Jobs=`cat $WORKING_DIR/projects/$project/$nuance/g4Events | cut -f2 -d$'\n'`
  detsimEvents=`cat $WORKING_DIR/projects/$project/$nuance/detsimEvents | cut -f1 -d$'\n'`
  echo 'Status: Complete'
  echo 'Ran '$g4Events' events over '$g4Jobs' jobs, and '$detsimEvents' passed'
else
  echo 'Status: Waiting...'
fi






echo ''
# DetSim Stage
if [ $stage == 3 ]; then
  if [ $action == 0 ]; then
    # action = 0 -> Idle
    echo 'Status: Idle'
  elif [ $action == 1 ]; then
    # action = 1 -> Submit
    detsimEvents=`cat $WORKING_DIR/projects/$project/$nuance/detsimEvents | cut -f1 -d$'\n'`
    detsimJobs=`cat $WORKING_DIR/projects/$project/$nuance/detsimEvents | cut -f2 -d$'\n'`
    echo 'Status: Submitting '$detsimEvents' events over '$detsimJobs' jobs'
    source $WORKING_DIR/helpers/job_submit_detsim.sh $project $nuance
    echo 2 > $WORKING_DIR/listeners/action
  elif [ $action == 2 ]; then
    # action = 2 -> Wait for jobs to finish
    echo 'Status: Waiting for jobs to finish'
    # Count the number of root files we have
    find /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/detsim/*/lar.stat -type f > $WORKING_DIR/projects/$project/$nuance/detsimStat
    detsimJobsDone=0
    detsimJobsGood=0
    while read line; do
      if [ `cat $line` == 0 ]; then
        detsimJobsGood=$(($detsimJobsGood + 1))
        filePath=$(readlink -f `dirname $line`)
        if [ `find $filePath/prodgenie*.root -type f | wc -l` == 1 ]; then
          detsimJobsDone=$(($detsimJobsDone + 1))
        fi 
      else
        detsimJobsDone=$(($detsimJobsDone + 1))  
      fi
    done < $WORKING_DIR/projects/$project/$nuance/detsimStat
    detsimJobs=`cat $WORKING_DIR/projects/$project/$nuance/detsimEvents | cut -f2 -d$'\n'`
    echo $detsimJobsDone' jobs complete of a total '$detsimJobs'. '$detsimJobsGood' were successful.'
    if [ $detsimJobsDone == $detsimJobs ]; then
      echo 3 > $WORKING_DIR/listeners/action 
    fi
  elif [ $action == 3 ]; then
    # action = 3 -> Check jobs
    echo 'Status: Checking jobs for good events'
    source $WORKING_DIR/helpers/job_check_detsim.sh $project $nuance
    echo 4 > $WORKING_DIR/listeners/action
  elif [ $action == 4 ]; then
    # action = 4 -> Prepare XML file for next stage
    echo 'Status: Preparing for signal processing'
    signalEvents=0
    while read line; do
      n=`echo $line | cut -f2 -d' '`
      signalEvents=$(($signalEvents + $n))
    done < '/pnfs/uboone/scratch/users/'$USER_NAME'/'$project'_'$nuance'/detsim/events.list'
    signalJobs=1
    #detsimJobs=`bc -l <<< $detsimEvents'/10'`
    #detsimJobs=`printf '%.*f' 0 $detsimJobs`
    echo $signalEvents > $WORKING_DIR/projects/$project/$nuance/signalEvents
    echo $signalJobs >> $WORKING_DIR/projects/$project/$nuance/signalEvents

    echo 1 > $WORKING_DIR/listeners/action
    echo 4 > $WORKING_DIR/listeners/stage
  fi
elif [ $stage -gt 1 ]; then
  detsimEvents=`cat $WORKING_DIR/projects/$project/$nuance/detsimEvents | cut -f1 -d$'\n'`
  detsimJobs=`cat $WORKING_DIR/projects/$project/$nuance/detsimEvents | cut -f2 -d$'\n'`
  signalEvents=`cat $WORKING_DIR/projects/$project/$nuance/signalEvents | cut -f1 -d$'\n'`
  echo 'Status: Complete'
  echo 'Ran '$detsimEvents' events over '$detsimJobs' jobs, and '$signalEvents' passed'
else
  echo 'Status: Waiting...'
fi

sleep 1
source $WORKING_DIR/listeners/listen_LAr-v4.sh $project 
