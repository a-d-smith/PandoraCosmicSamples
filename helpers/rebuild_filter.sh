#!/bin/bash


# Arguments
#   1) name of the new project
if [ $# -ne 1 ]; then
  echo "Error: Please pass the name of your new project as a parameter"
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

# Set up the fcl file and re-build for 1001
cp $WORKING_DIR/generic/fcl/myfilter.fcl $MRB_SOURCE/myfiltermodule/myfiltermodule/.
sed -i -e 's,NUANCE,1001,g' $MRB_SOURCE/myfiltermodule/myfiltermodule/myfilter.fcl
cd $MRB_BUILDDIR
mrbsetenv
mrb i
mrbslp
cd $WORKING_DIR/projects/$name/1001
tar -C $MRB_INSTALL -czf local.tar .


# Set up the fcl file and re-build for 1003
cp $WORKING_DIR/generic/fcl/myfilter.fcl $MRB_SOURCE/myfiltermodule/myfiltermodule/.
sed -i -e 's,NUANCE,1003,g' $MRB_SOURCE/myfiltermodule/myfiltermodule/myfilter.fcl
cd $MRB_BUILDDIR
mrbsetenv
mrb i
mrbslp
cd $WORKING_DIR/projects/$name/1003
tar -C $MRB_INSTALL -czf local.tar .


# Set up the fcl file and re-build for 1004
cp $WORKING_DIR/generic/fcl/myfilter.fcl $MRB_SOURCE/myfiltermodule/myfiltermodule/.
sed -i -e 's,NUANCE,1004,g' $MRB_SOURCE/myfiltermodule/myfiltermodule/myfilter.fcl
cd $MRB_BUILDDIR
mrbsetenv
mrb i
mrbslp
cd $WORKING_DIR/projects/$name/1004
tar -C $MRB_INSTALL -czf local.tar .

cd $WORKING_DIR
