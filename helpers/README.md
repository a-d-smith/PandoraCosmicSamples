PandoraCosmicSamples Helper Scripts
===================================
In this directory are various scripts you can use to produce samples on the fermi-grid.

To organise all of the files required, you first have to create a **project** which is 
basically a directory holding all the files you require to submit jobs to the grid.

Within each project subdirectories are produced for three different interation types
  - CCQE (nuance code 1001)
  - CCRES charged pion production (nuance code 1003)
  - CCRES neutral pion production (nuance code 1004)

Below is a list of all the helper functions available

1.  [`new_project.sh`](#new_projectsh) 
2.  [`rebuild_filter.sh`](#rebuild_filtersh) 
3.  [`job_submit_gen.sh`](#job_submit_gensh)
4.  [`job_submit_g4.sh`](#job_submit_g4sh)
5.  [`job_submit_detsim.sh`](#job_submit_detsimsh)
6.  [`job_check_gen.sh`](#job_check_gensh)
7.  [`job_check_g4.sh`](#job_check_g4sh)
8.  [`job_check_detsim.sh`](#job_check_detsimsh)
9.  [`job_clean_gen.sh`](#job_clean_gensh)
10. [`job_clean_g4.sh`](#job_cleab_g4sh)
11. [`job_clean_detsim.sh`](#job_clean_detsimsh)
12. [`job_status.sh`](#job_statussh)
13. [`job_logs_gen.sh`](#job_logs_gensh)
14. [`job_logs_g4.sh`](#job_logs_g4sh)
15. [`job_logs_detsim.sh`](#job_logs_detsimsh)

----------------------------------------------------------------------------------------

How to submit jobs
------------------

### Make sure you have LArSoft-v4_36_00_03 setup
The first few stages will require LArSoft-v4_36_00_03. So from a fresh terminal, set it up
using
```bash
source setup/setup_all_v04_36_00_04.sh
```

### Make a new project
First, you will need to make a project. For this example we will call it `my_project`
```bash
source helpers/new_project.sh my_project
```
You can now now `ls -R projects/my_project` to see how the directory structure works.


### Define now many jobs you want
The production chain produced by `new_project.sh` for the production of some CCQE events (for example) 
can be found under `projects/my_project/1001/prod_chain_1001.xml`. In here you can set the
total number of events you want to produce by modifying:
```xml
<numevents>1000</numevents> 
``` 
**Note**. This will not be the number of events you will end up with! Some jobs will probably fail, 
and since we are filtering events based on nuance code, you will always loose events.

These events can be split up into multiple jobs, you can set the number of jobs for the 
generator stage (for example) by modifying this line
```xml
<stage name="gen">
  ...
  <numjobs>10</numjobs>
  ...
</stage>
```
The other stages can be modified in a similar way.

### Generator stage
Once you have set the total number of events, and the number of jobs in which to process
those events, you can submit your jobs to the grid using:
```bash
source helpers/job_submit_gen.sh my_project 1001
```
This will run the generator stage. You can then see the status of your jobs by running:
```bash
source helpers/job_status.sh my_project 1001
```
This will give you a line from `project.py` that looks something like this
```
Stage gen batch jobs: 10 idle, 0 running, 0 held, 0 other.
```
Keep checking on them until they have all finished. Once they are done, you need to *check*
the jobs. This will tell you how many of them succeeded and how many failed. 
```bash
source helpers/job_check_gen.sh my_project 1001
```
You can then request the path for the output files for your jobs by using
```bash
source helpers/job_logs_gen.sh my_project 1001
```
This may give you some insight as to what went wrong.

#### Known issue
Most frequently, the issue is something related to "negative interaction probability" in 
GENIE. The best way forward seems to be to discard that job and continue anyway.


----------------------------------------------------------------------------------------

`new_project.sh`
--------------
This script will generate a new project of the name supplied

### Arguments
```bash
source helpers/new_project.sh myProjectName
```
1. A unique name for your project

### Detail
The script produces a new directory under `projects/`, and subdirectories for 1001, 1003 & 1004.
Within each subdirectory, a *production chain* .xml file (`prodchain_1001.xml` for example) is produced 
which defines what will get submitted to the grid. The production chain has 3 stages (which will be done
in LArSoft-v4_36_00_03)

1. **gen**. This stage will use outputs from GENIE with cosmics. See the xml, for the relecant fcl file for a given stage
2. **g4**. This stage runs GEANT4 and the filter module to only select events with the required nuance code.
The filter has a settings fcl file called `myfilter.fcl` which is modified for each stage by `new_project.sh`.
The filter and relevant files from the LArSoft installation are then tarballed in `local.tar`, and this is passed to the grid.
If you wish to modify the filter algorithm, you must re-build it and produce a tarball for each nuance code. This can be done
with `rebuild_filter.fcl`.
3. **detsim**. This is just the standard detector simulation with no modifications

----------------------------------------------------------------------------------------

`rebuild_filter.sh`
-------------------
This script will recomplile my filter and make a new tarball for each of the nuance codes (see [`new_project.sh`](#new_projectsh) for more details)

### Arguments
```bash
source helpers/rebuild_filter.sh myProjectName
```
1. A unique name for your project

----------------------------------------------------------------------------------------

`job_submit_gen.sh`
-------------------
This script will submit your jobs to the grid for the generator stage using `project.py`.

### Arguments
```bash
source helpers/job_submit_gen.sh myProjectName nuanceCode
```
1. The name of your project
2. The nuance code you wish to submit (1001, 1003 or 1004)

----------------------------------------------------------------------------------------

`job_submit_g4.sh`
------------------
This script will submit your jobs to the grid for the g4 and filtering stage using `project.py`.

### Arguments
```bash
source helpers/job_submit_gen.sh myProjectName nuanceCode
```
1. The name of your project
2. The nuance code you wish to submit (1001, 1003 or 1004)

----------------------------------------------------------------------------------------

`job_submit_detsim.sh`
----------------------

----------------------------------------------------------------------------------------

`job_check_gen.sh`
----------------------

----------------------------------------------------------------------------------------

`job_check_g4.sh`
----------------------

----------------------------------------------------------------------------------------

`job_check_detsim.sh`
----------------------

----------------------------------------------------------------------------------------

`job_clean_gen.sh`
----------------------

----------------------------------------------------------------------------------------

`job_clean_g4.sh`
----------------------

----------------------------------------------------------------------------------------

`job_clean_detsim.sh`
----------------------

----------------------------------------------------------------------------------------

`job_status.sh`
----------------------

----------------------------------------------------------------------------------------

`job_logs_gen.sh`
----------------------

----------------------------------------------------------------------------------------

`job_logs_g4.sh`
----------------------

----------------------------------------------------------------------------------------

`job_logs_detsim.sh`
----------------------

----------------------------------------------------------------------------------------
