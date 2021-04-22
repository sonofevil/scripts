#!/usr/bin/bash

#This script watches a folder and creates incremental backups of every changed file in another folder.

#Folder structure looks like this: 

# backup/ 
# ├── YYYYMMDDhhmmss/           <--- initial full backup 
# |     ├── file_a 
# |     ├── file_b 
# |     ├── file_c 
# |     ├── file_d 
# ├── file_a.YYYYMMDDhhmmss     <--- real time backup 
# ├── file_c.YYYYMMDDhhmmss 
# ├── file_a.YYYYMMDDhhmmss 
# ... 

#Dependencies:
# inotifywait
# rsync

#Watch directory:
WAPA="~"

#Backup directory:
BDIR="~/backup/"
mkdir $BDIR

#Exclude subdirectory:
EXCL=/backup

#Initial backup of entire directory content:
rsync -avz --exclude "$EXCL" "$WAPA" "$BDIR/`date "+%Y%m%d%H%M%S"`/"

#start child process:
(
#File changing app:
nano
#Kill inotifaywait after app terminates:
killall inotifywait
echo
echo "All done."
) &

#App might crash if rsync starts too early.
sleep 5

#Start inotifywait and write filenames to variable.
#Loop will run each time a file changes.
#I can't believe this actually works:
while FIPA=$(inotifywait --format %w%f -q -e modify --exclude "'"$EXCL*"'" -r "$WAPA")
do
    #Print file path for debug:
    echo "$FIPA"
    #Get filename form path:
    FINA=`basename "$FIPA"`
    
    #Backup file to backup directory with current time (YYYYMMDDHHmmss) as extension:
    rsync -avz "$FIPA" "$BDIR/$FINA.`date "+%Y%m%d%H%M%S"`"
    
    #Reset variables:
    FINA=""
    FIPA=""
done
