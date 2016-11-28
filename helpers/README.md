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

1. [`new_project.sh`](#new_projectsh) 
2. [`rebuild_filter.sh`](#rebuild_filtersh) 
3. [`job_submit_gen.sh`](#job_submit_gensh)
4. [`job_submit_g4.sh`](#job_submit_g4sh)
5. [`job_submit_detsim.sh`](#job_submit_detsimsh)
6. [`job_check_gen.sh`](#job_check_gensh)
6. [`job_check_g4.sh`](#job_check_g4sh)
6. [`job_check_detsim.sh`](#job_check_detsimsh)
6. [`job_clean_gen.sh`](#job_clean_gensh)
6. [`job_clean_g4.sh`](#job_cleab_g4sh)
6. [`job_clean_detsim.sh`](#job_clean_detsimsh)
6. [`job_status.sh`](#job_statussh)


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



`rebuild_filter.sh`
-------------------
This script will recomplile my filter and make a new tarball for each of the nuance codes

### Arguments
```bash
source helpers/rebuild_filter.sh myProjectName
```
1. A unique name for your project
