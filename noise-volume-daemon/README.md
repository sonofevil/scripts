# noise-volume-daemon
Bash script which dynamically fades in/out the volume of an audio-generating process (e.g. an ambient noise generator like anoise.py) in response to whether other processes are using audio. Requires Pulseaudio. Uses pipes that might be fragile. Can't tell the difference between paused and playing audio.

By default the script works with anoise.py. However it can be made to work with any audio-generating process by simply changing the following line in the code accordingly:

> NOISEPROC="anoise.py"

Use `pacmd list-sink-inputs` and look for `application.name` lines to find the names of processes currently using audio.
