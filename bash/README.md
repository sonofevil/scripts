I cannot guarantee that any of these scripts will work on any system that is in the slightest way different from mine.

## menuentry.sh

GUI wizard which creates a menu entry under KDE for an executable file given as an argument.

## backupwatch.sh

Creates a backup of a folder and starts an app, and continues to create backups of any changed file in that folder until the app terminates.
For now configuration is done inside script. Requires rsync and inotifywatch.

## noised.sh

Bash script which dynamically fades in/out the volume of an audio-generating process (e.g. an ambient noise generator like anoise.py) in response to whether other processes are using audio. Requires Pulseaudio. Uses pipes that might be fragile. Can't tell the difference between paused and playing audio.

By default the script works with anoise.py. However it can be made to work with any audio-generating process by simply changing the following line in the code accordingly:

> NOISEPROC="anoise.py"

Use `pacmd list-sink-inputs` and look for `application.name` lines to find the names of processes currently using audio.
