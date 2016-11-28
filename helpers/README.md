PandoraCosmicSamples Helper Scripts
===================================
In this directory are various scripts you can use to produce samples on the fermi-grid.

To organise all of the files required, you first have to create a **project** which is 
basically a directory holding all the files you require to submit jobs to the grid.

Within each project subdirectories are produced for three different interation types
  - CCQE (nuance code 1001)
  - CCRES charged pion production (nuance code 1003)
  - CCRES neutral pion production (nuance code 1004)



new_project.sh
--------------
### Brief
This script will generate a new project of the name supplied

### Arguments
1. A unique name for your project

Run with
```
source new_project.sh myProjectName
```
