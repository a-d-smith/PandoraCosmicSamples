#!/bin/bash

# Arguments
#   1) name of the project
#   2) nuance code
if [ $# -ne 2 ]; then
  echo "Error: Please pass the following a parameters"
  echo "       1. Name of the project"
  echo "       2. Nuance code (1001, 1003 or 1004)"
  return
fi

# Check that the project doesn't already exist
existing_projects=`find $WORKING_DIR/projects -mindepth 1 -maxdepth 1 -type d`
project_exists=false
for project in $existing_projects;
do
  if [ `basename $project` == $1 ]; then
    project_exists=true
  fi
done

if [ $project_exists == false ]; then
  echo "Error: I can't find a project with that name. Please try again"
  echo "       You currently have the following projects"
  for project in $existing_projects;
  do
    echo "         "`basename $project`
  done
  return
fi

project=$1

if [ $2 != "1001" -a $2 != "1003" -a $2 != "1004"  ]; then
  echo "Error: You need to supply one of the specified nuance codes"
  echo "       1001 -> CCQE"
  echo "       1003 -> CCQE charged pion"
  echo "       1004 -> CCQE neutral pion"
  return
fi

nuance=$2

if [ ! -f /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/detsim/events.list ]; then
  echo "Error: The following file doesn't exist"
  echo /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/detsim/events.list
  return
fi

# Submit the jobs to the grid manually
mkdir /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/sig

index=0
while read line;
do
  file=`echo $line | cut -f1 -d' '`
  events=`echo $line | cut -f2 -d' '`

  if [ $events -ne 0 ]; then  
    echo "Submitting job with $events events"
    mkdir /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/sig/$index
  
    # Make a submission script for this file
    cp $WORKING_DIR/generic/sh/job_grid_signal_processing.sh $WORKING_DIR/projects/$project/$nuance/job_grid_signal_processing_${project}_${nuance}_${index}.sh
    sed -i -e 's,USER_NAME,'`echo $USER_NAME`',g' $WORKING_DIR/projects/$project/$nuance/job_grid_signal_processing_${project}_${nuance}_${index}.sh
    sed -i -e 's,WORKING_DIR,'`echo $WORKING_DIR`',g' $WORKING_DIR/projects/$project/$nuance/job_grid_signal_processing_${project}_${nuance}_${index}.sh
    sed -i -e 's,PROJECT,'`echo $project`',g' $WORKING_DIR/projects/$project/$nuance/job_grid_signal_processing_${project}_${nuance}_${index}.sh
    sed -i -e 's,NUANCE,'`echo $nuance`',g' $WORKING_DIR/projects/$project/$nuance/job_grid_signal_processing_${project}_${nuance}_${index}.sh
    sed -i -e 's,IN_DIR,'`dirname $file`',g' $WORKING_DIR/projects/$project/$nuance/job_grid_signal_processing_${project}_${nuance}_${index}.sh
    sed -i -e 's,INDEX,'`echo $index`',g' $WORKING_DIR/projects/$project/$nuance/job_grid_signal_processing_${project}_${nuance}_${index}.sh

    jobsub_submit -N 1 --OS=SL6 --group uboone --role=Analysis file://$WORKING_DIR/projects/$project/$nuance/job_grid_signal_processing_${project}_${nuance}_${index}.sh 
 
    index=$(($index + 1))
  fi
done < /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/detsim/events.list



