#!/bin/sh

### Gradually silences noise process if there is other audio output
### and gradually turns it back up if nothing else uses audio

function checksound {
        # Returns 1 to $? if only noise process is playing, otherwise 0.
        pacmd list-sink-inputs | grep -e 'state:' -e "application.name =" | tr '\n' '%' | sed -e "s|%..application| |g" | tr '%' '\n' | grep -v "$NOISEPROC" | grep -q "RUNNING"
}

function checkvol { 
        # Reads noise process volume.
        NOISEVOL=`pacmd list-sink-inputs | grep -e 'volume:' -e "application.name =" | tr '\n' '#' | sed -e "s|#..application| |g" | tr '#' '\n' | grep "$NOISEPROC" | grep -oP '(?<=/).*?(?=% /)' | head -1 | awk '{$1=$1};1'`
}

checkvol

# Stores noise volume level prior to fading out.
SAVEDVOL=$NOISEVOL
# Set to true after volume is restored.
ISFULL=true

while true; do

    # Set noise process name.
    NOISEPROC="anoise.py"
    
    # Reads pulseaudio sink number of noise process.
    NOISESINK=`pacmd list-sink-inputs | grep -e 'index:' -e "application.name =" | tr '\n' '%' | sed -e "s|%..application| |g" | tr '%' '\n' | grep "$NOISEPROC" | grep -oP '(?<=index:).*?(?=.name)' | awk '{$1=$1};1'`
    
    echo "Noise sink:   $NOISESINK"
    echo "Saved volume: $SAVEDVOL%"
    
    checksound
    
    # If only noise process is playing...
    if [ $? -eq 1 ]; then    
    
        echo "Silence"
        
        # Unmutes noise process.
        pactl set-sink-input-mute $NOISESINK false
        
        checkvol
        
        # If volume has not yet been restored...
        if [ "$ISFULL" = false ]; then
        
            # Gradually increase noise process volume to SAVEDVOL
            for ((i=$NOISEVOL;i<=$SAVEDVOL;i+=1)); do 
            
                # Sets noise volume to counter.
                pactl set-sink-input-volume $NOISESINK $i%
                
                echo "$i%"
                
                # If volume is restored...
                if [ $i -eq $SAVEDVOL ]; then 
                
                    # Skips future fade-ins.
                    ISFULL=true
                    
                    echo "Volume Restored"
                    
                fi
                
                checksound
                
                # Aborts fade if sound state changes.
                if [ $? -eq 0 ]; then i=$SAVEDVOL; fi
                
                sleep 0.05
                
            done
            
        fi
      
    # If something else is playing...
    else
    
        echo "Sound"
        
        checkvol
        
        # If previous fade-in was completed...
        if [ "$ISFULL" = true ]; then
        
            # Stores manually adjusted volume. 
            SAVEDVOL=$NOISEVOL
            
            # Allow future fade-ins.
            ISFULL=false
            
        fi
        
        # Fade out noise volume.
        for ((i=$NOISEVOL;i>=1;i-=1)); do 
        
            # Decrease volume by 1.
            pactl set-sink-input-volume $NOISESINK -1%
            
            # If i diverges from actual volume decrease, this will be misleading.
            echo "$i%"
            
            checksound
            
            # Aborts fade if sound state changes.
            if [ $? -eq 1 ]; then i=0; fi
            
            sleep 0.05
            
        done
        
    fi
    
  date
  
  # Wait 1 second.
  sleep 1
  
done
