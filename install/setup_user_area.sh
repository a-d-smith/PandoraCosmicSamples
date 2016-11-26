#!/bin/bash

echo ""

# Make sure that the user is running from the repo
if [ "`basename $(pwd)`" != "PandoraCosmicSamples" ]; then
  echo "Oops: You need to run this script from the directory \"PandoraCosmicSamples\""
  echo "      This is so I can setup your working area to be inside the repo you cloned from github!"
  echo ""
  echo "      You should be typing:"
  echo "      source install/setup_user_area.sh"
  echo ""
  return
fi

# Make sure the user has an area to hold their grid jobs
export USER_NAME=`whoami`
if [ ! -d /pnfs/uboone/scratch/users/$USER_NAME ]; then
  echo "Error: You don't seem to have a user area under /pnfs/uboone/scratch/users/$USER_NAME"
  echo "       If you have the permissions, you can just make a directory here by typing:"
  echo "       mkdir /pnfs/uboone/scratch/users/$USER_NAME"
  echo ""
  return
fi

export SCRATCH_DIR=/pnfs/uboone/scratch/users/$USER_NAME

# If the user doesn't already have a directory for grid work, then make them one!
if [ ! -d $SCRATCH_DIR/work ]; then
  mkdir $SCRATCH_DIR/work
fi

# Set up some useful variables
export WORKING_DIR=`pwd`

echo "Your user area seems good!"
