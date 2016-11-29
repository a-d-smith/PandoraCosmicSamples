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


# Get a copy of the events list for the g4 stage
cp '/pnfs/uboone/scratch/users/'`echo $USER_NAME`'/'`echo $project`'_'`echo $nuance`'/g4/events.list' $WORKING_DIR/projects/$project/g4_events.list

# Ideally we want around 10 events to run through detsim so the files don't get huge
for line in `cat $WORKING_DIR/projects/$project/g4_events.list`; do
  echo $line
done 

