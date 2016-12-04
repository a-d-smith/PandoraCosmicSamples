#!/bin/bash

# Arguments
#   1) name of the new project
#   2) number of events of nuance 1001
#   3) number of events of nuance 1003
#   4) number of events of nuance 1004
if [ $# -ne 4 ]; then
  echo "Error: Please pass the following as parameters"
  echo "         1. A unique name for your project"
  echo "         2. The number of 1001 events you require"
  echo "         4. The number of 1003 events you require"
  echo "         5. The number of 1004 events you require"
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

if [ $project_exists == true ]; then
  echo "Error: A project with that name already exists. Please choose another name"
  echo "       You currently have the following projects"
  for project in $existing_projects;
  do
    echo "         "`basename $project`
  done
  return
fi

# Check that a sensible number has been given for the events
if [[ $2 =~ [^0-9] ]]; then
  echo "Error: Invalid number of events given for nuance 1001"
  return
fi
if [[ $3 =~ [^0-9] ]]; then
  echo "Error: Invalid number of events given for nuance 1003"
  return
fi
if [[ $4 =~ [^0-9] ]]; then
  echo "Error: Invalid number of events given for nuance 1004"
  return
fi
if [ $2 == 0 -a $3 == 0 -a $4 == 0 ]; then
  echo "Error: You have requested no events!"
  return
fi


# Make a directory for the new project
name=$1
mkdir $WORKING_DIR/projects/$name
cd $WORKING_DIR/projects/$name

# Make a production chain xml file for 1001 nuance code
if [ $2 != 0 ]; then
  mkdir 1001
  cd 1001
  cp $WORKING_DIR/generic/xml/prod_chain_cosmic_generic.xml prod_chain_1001.xml
  sed -i -e 's,USER_NAME,'`echo $USER_NAME`',g' prod_chain_1001.xml
  sed -i -e 's,PROJECT,'`echo $name`',g' prod_chain_1001.xml
  sed -i -e 's,NUANCE_CODE,1001,g' prod_chain_1001.xml
  sed -i -e 's,WORKING_DIR,'`echo $WORKING_DIR`',g' prod_chain_1001.xml
  sed -i -e 's,PRODGENIE_FCL,my_prodgenie_cosmic_ccqe.fcl,g' prod_chain_1001.xml
 
  genEvents=`bc -l <<< $2'/0.35'`
  genJobs=`bc -l <<< $genEvents'/10'`
  genJobs=`printf '%.*f' 0 $genJobs`
  genEvents=`bc -l <<< $genJobs'*10'`

  sed -i -e 's,GEN_EVENTS,'`echo $genEvents`',g' prod_chain_1001.xml
  sed -i -e 's,GEN_JOBS,'`echo $genJobs`',g' prod_chain_1001.xml
  sed -i -e 's,G4_EVENTS,0,g' prod_chain_1001.xml
  sed -i -e 's,G4_JOBS,0,g' prod_chain_1001.xml
  sed -i -e 's,DETSIM_EVENTS,0,g' prod_chain_1001.xml
  sed -i -e 's,DETSIM_JOBS,0,g' prod_chain_1001.xml

  echo $2 > requestedEvents
  echo $genEvents > genEvents
  echo $genJobs >> genEvents
 
  # Modify the filter, build it and make the tar
  cp $WORKING_DIR/generic/fcl/myfilter.fcl $MRB_SOURCE/myfiltermodule/myfiltermodule/.
  sed -i -e 's,NUANCE,1001,g' $MRB_SOURCE/myfiltermodule/myfiltermodule/myfilter.fcl
  cd $MRB_BUILDDIR
  mrbsetenv
  mrb i
  mrbslp
  cd $WORKING_DIR/projects/$name/1001
  tar -C $MRB_INSTALL -czf local.tar .
  cd ..
fi

# Make a production chain xml file for 1003 nuance code
if [ $3 != 0 ]; then
  mkdir 1003
  cd 1003
  cp $WORKING_DIR/generic/xml/prod_chain_cosmic_generic.xml prod_chain_1003.xml
  sed -i -e 's,USER_NAME,'`echo $USER_NAME`',g' prod_chain_1003.xml
  sed -i -e 's,PROJECT,'`echo $name`',g' prod_chain_1003.xml
  sed -i -e 's,NUANCE_CODE,1003,g' prod_chain_1003.xml
  sed -i -e 's,WORKING_DIR,'`echo $WORKING_DIR`',g' prod_chain_1003.xml
  sed -i -e 's,PRODGENIE_FCL,my_prodgenie_cosmic_res.fcl,g' prod_chain_1003.xml

  genEvents=`bc -l <<< $2'/0.17'`
  genJobs=`bc -l <<< $genEvents'/10'`
  genJobs=`printf '%.*f' 0 $genJobs`
  genEvents=`bc -l <<< $genJobs'*10'`

  sed -i -e 's,GEN_EVENTS,'`echo $genEvents`',g' prod_chain_1003.xml
  sed -i -e 's,GEN_JOBS,'`echo $genJobs`',g' prod_chain_1003.xml
  sed -i -e 's,G4_EVENTS,0,g' prod_chain_1003.xml
  sed -i -e 's,G4_JOBS,0,g' prod_chain_1003.xml
  sed -i -e 's,DETSIM_EVENTS,0,g' prod_chain_1003.xml
  sed -i -e 's,DETSIM_JOBS,0,g' prod_chain_1003.xml

  echo $3 > requestedEvents
  echo $genEvents > genEvents
  echo $genJobs >> genEvents
  
  # Modify the filter, build it and make the tar
  cp $WORKING_DIR/generic/fcl/myfilter.fcl $MRB_SOURCE/myfiltermodule/myfiltermodule/.
  sed -i -e 's,NUANCE,1003,g' $MRB_SOURCE/myfiltermodule/myfiltermodule/myfilter.fcl
  cd $MRB_BUILDDIR
  mrbsetenv
  mrb i
  mrbslp
  cd $WORKING_DIR/projects/$name/1003
  tar -C $MRB_INSTALL -czf local.tar .
  cd ..
fi

# Make a production chain xml file for 1001 nuance code
if [ $4 != 0 ]; then
  mkdir 1004
  cd 1004
  cp $WORKING_DIR/generic/xml/prod_chain_cosmic_generic.xml prod_chain_1004.xml
  sed -i -e 's,USER_NAME,'`echo $USER_NAME`',g' prod_chain_1004.xml
  sed -i -e 's,PROJECT,'`echo $name`',g' prod_chain_1004.xml
  sed -i -e 's,NUANCE_CODE,1004,g' prod_chain_1004.xml
  sed -i -e 's,WORKING_DIR,'`echo $WORKING_DIR`',g' prod_chain_1004.xml
  sed -i -e 's,PRODGENIE_FCL,my_prodgenie_cosmic_res.fcl,g' prod_chain_1004.xml
  
  genEvents=`bc -l <<< $2'/0.06'`
  genJobs=`bc -l <<< $genEvents'/10'`
  genJobs=`printf '%.*f' 0 $genJobs`
  genEvents=`printf '%.*f' 0 $genEvents`

  sed -i -e 's,GEN_EVENTS,'`echo $genEvents`',g' prod_chain_1004.xml
  sed -i -e 's,GEN_JOBS,'`echo $genJobs`',g' prod_chain_1004.xml
  sed -i -e 's,G4_EVENTS,0,g' prod_chain_1004.xml
  sed -i -e 's,G4_JOBS,0,g' prod_chain_1004.xml
  sed -i -e 's,DETSIM_EVENTS,0,g' prod_chain_1004.xml
  sed -i -e 's,DETSIM_JOBS,0,g' prod_chain_1004.xml

  echo $4 > requestedEvents
  echo $genEvents > genEvents
  echo $genJobs >> genEvents

  # Modify the filter, build it and make the tar
  cp $WORKING_DIR/generic/fcl/myfilter.fcl $MRB_SOURCE/myfiltermodule/myfiltermodule/.
  sed -i -e 's,NUANCE,1004,g' $MRB_SOURCE/myfiltermodule/myfiltermodule/myfilter.fcl
  cd $MRB_BUILDDIR
  mrbsetenv
  mrb i
  mrbslp
  cd $WORKING_DIR/projects/$name/1004
  tar -C $MRB_INSTALL -czf local.tar .
  cd ..
fi

cd $WORKING_DIR
