PandoraCosmicSamples
====================
A set of helpful scripts to make the production of sampes for pandora easier!  
**This is the develop branch so beware of things that may not work!**



Getting Started
---------------
Clone this repo from github using
```
git clone https://github.com/a-d-smith/PandoraCosmicSamples.git
```

cd into `PandoraCosmicSamples`. Then check your user area is okay and setup some environment variables using
```
source install/setup_user_area.sh
```

Now install LArSoft-v04_36_00_03, and myfiltermodule using
```
source install/install_dependencies_part1.sh
```

At this point, your terminal is set up for using LArSoft-v04_36_00_03. 
But, the next thing we want to do is install LArSoft-v05_08_00_05 so you will need to end your ssh session on the fermilab machine using `logout`, 
then log back in again and cd to `PandoraCosmicSamples`

Now install LArSoft-v05_08_00_05 using
```
source install/install_dependencies_part2.sh
```

The next thing you will probably want to do is to produce some samples by first running GENIE, this requires LArSoft-v04_36_00_03 so you will
once again have to `logout` and see [Starting from a fresh terminal](#Starting-from-a-fresh-terminal) to set set up again.


Starting from a fresh terminal
------------------------------
When you log in from a fresh terminal, you will need to set up LArSoft.
If you wish to run GENIE, G4, Filter or Detsim... Then you will need to set up LArSoft-v04_36_00_03
```
source setup/setup_all_v04_36_00_04.sh
```
You will be asked for your FNAL.GOV password, this is required to allow you to work on the grid!

If you wish to run Pandora writer on a detsim file to make a .pndr file, then you will need to set up LArSoft-v05_08_00_05
```
source setup/setup_all_v05_08_00_05.sh
```

If you wish to switch between LArSoft versions, you must use a fresh terminal (or `logout` and log back in again) then source the required setup script.



