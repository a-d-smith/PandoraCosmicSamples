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

if [ $project_exists == true ]; then
  echo "Error: A project with that name already exists. Please choose another name"
  echo "       You currently have the following projects"
  for project in $existing_projects;
  do
    echo "         "`basename $project`
  done
  return
fi

# Make a directory for the new project
name=$1
mkdir $WORKING_DIR/projects/$name
cd $WORKING_DIR/projects/$name

# Make a production chain xml file for 1001 nuance code
mkdir 1001
cd 1001
cp $WORKING_DIR/generic/xml/prod_chain_cosmic_generic.xml prod_chain_1001.xml
sed -i -e 's,USER_NAME,'`echo $USER_NAME`',g' prod_chain_1001.xml
sed -i -e 's,PROJECT,'`echo $name`',g' prod_chain_1001.xml
sed -i -e 's,NUANCE_CODE,1001,g' prod_chain_1001.xml
sed -i -e 's,WORKING_DIR,'`echo $WORKING_DIR`',g' prod_chain_1001.xml
sed -i -e 's,PRODGENIE_FCL,my_prodgenie_cosmic_ccqe.fcl,g' prod_chain_1001.xml
cd ..


# Make a production chain xml file for 1003 nuance code
mkdir 1003
cd 1003
cp $WORKING_DIR/generic/xml/prod_chain_cosmic_generic.xml prod_chain_1003.xml
sed -i -e 's,USER_NAME,'`echo $USER_NAME`',g' prod_chain_1003.xml
sed -i -e 's,PROJECT,'`echo $name`',g' prod_chain_1003.xml
sed -i -e 's,NUANCE_CODE,1003,g' prod_chain_1003.xml
sed -i -e 's,WORKING_DIR,'`echo $WORKING_DIR`',g' prod_chain_1003.xml
sed -i -e 's,PRODGENIE_FCL,my_prodgenie_cosmic_res.fcl,g' prod_chain_1003.xml
cd ..

# Make a production chain xml file for 1001 nuance code
mkdir 1004
cd 1004
cp $WORKING_DIR/generic/xml/prod_chain_cosmic_generic.xml prod_chain_1004.xml
sed -i -e 's,USER_NAME,'`echo $USER_NAME`',g' prod_chain_1004.xml
sed -i -e 's,PROJECT,'`echo $name`',g' prod_chain_1004.xml
sed -i -e 's,NUANCE_CODE,1004,g' prod_chain_1004.xml
sed -i -e 's,WORKING_DIR,'`echo $WORKING_DIR`',g' prod_chain_1004.xml
sed -i -e 's,PRODGENIE_FCL,my_prodgenie_cosmic_res.fcl,g' prod_chain_1004.xml
cd $WORKING_DIR
