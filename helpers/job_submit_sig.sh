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
  echo "Error: You must check the detsim stage before running this script"
  return
fi

# Get the number of jobs we require
while read line;
do
  echo File: `echo line | cut -f1 -d' '`
  echo Events: `echo line | cut -f2 -d' '`
done < /pnfs/uboone/scratch/users/$USER_NAME/$project'_'$nuance/detsim/events.list
