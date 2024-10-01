#!/usr/bin/bash
# Script taken from https://www.reddit.com/r/kde/comments/gim0hx/hotkey_to_toggle_muteunmute_active_application/

window=$(xdotool getactivewindow getwindowpid)     #get active window pid 

tempvar=$(pactl list sink-inputs |     #temp variable with all items producing sound in format "Sink_Input_numr" "pid" "Sink_Input_num" "pid" etc.
 grep 'Sink Input #\|application\.process\.id =' |
 while read -r line ; do
 echo $line | grep -oP 'Sink Input #\K[^$]+'
 echo $line | grep -oP 'application\.process\.id = "\K[^"]+'
 done |
 tr '\n' ' ')

array=($tempvar)     #array containing all items in $tempvar

for (( i = 1; i < ${#array[*]}; i+=2 )); do     #for all array ellements
        if [[ $window == ${array[$i]} ]]; then     #compare active window pid and programs' pid that produce sound
                actual_array_number=$(($i-1))     #because of the nature of the array subtract 1 to find Sink_Input_number
                pactl set-sink-input-mute ${array[$actual_array_number]} toggle     #toggle audio for that app on or off

				#echo $window , ${array[actual_array_number]}
                #break     #don't continue the loop just exit
        fi
done
