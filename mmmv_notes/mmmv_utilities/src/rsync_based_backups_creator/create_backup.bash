#!/bin/bash 
#==========================================================================


I_NUMBER_OF_BACKUP_VERSIONS=3  # Please update to comply with Your wishes.


#--------------------------------------------------------------------------
source `pwd`/bonnet/engine_part_1.bash
S_RSYNC_COMMAND_PREFIX="nice -n10 rsync -avz --delete "
#--------------------------------------------------------------------------

# The next line shows, how to create a backup of the whole $HOME folder.
#$S_RSYNC_COMMAND_PREFIX $HOME $S_FULL_PATH_TO_THE_BACKUP_FOLDER

# The S_FULL_PATH_TO_THE_BACKUP_FOLDER is (automatically) initiated 
# within the included `pwd`/bonnet/engine_part_1.bash

sync # Motivated by the use of external USB drives/sticks.
#==========================================================================

