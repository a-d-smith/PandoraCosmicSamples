#!/bin/bash

# Arguments
#   1) name of the new project
if [ $# -ne 1 ]; then
  echo "Error: Please pass the name of your new project as a parameter"
  return
fi

# Check that the project doesn't already exist
# existing_projects=`find $WORKING_DIR/projects -mindepth 1 -maxdepth 1 -type d` 
