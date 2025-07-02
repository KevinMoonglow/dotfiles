#!/bin/bash

# Get the PID of the process associated with that window
if [ "$DESKTOP_SESSION" == "hyprland" ]; then
	focused_pid=$(hyprctl activewindow -j | jq .pid)
elif [ "$DESKTOP_SESSION" == "niri" ]; then
	focused_pid=$(niri msg -j focused-window | jq .pid)
else
	focused_pid=$(xdotool getactivewindow getwindowpid)
fi


# Find the sink input (audio stream) that matches the focused PID
sink_input=($(pactl list sink-inputs | awk -v pid="$focused_pid" '
  $1 == "Sink" && $2 == "Input" {
    input_index = $3
  }
  $1 == "application.process.id" {
    if ($3 == "\""pid"\"") {
		sub(/^#/, "", input_index)
		print input_index
    }
  }
'))

if [ -z "$sink_input" ]; then
  echo "No audio stream found for focused window (PID: $focused_pid)."
  exit 1
fi

# Get current mute status
current_mute=$(pactl list sink-inputs | awk -v id="${sink_input[0]}" '
  $1 == "Sink" && $2 == "Input" && $3 == "#"id {
    found = id
  }
  found && $1 == "Mute:" {
    print $2
    exit
  }
')

# Toggle mute
if [ "$current_mute" == "yes" ]; then
  printf "%s\n" ${sink_input[@]} | xargs -I{} pactl set-sink-input-mute {} 0
else
  printf "%s\n" ${sink_input[@]} | xargs -I{} pactl set-sink-input-mute {} 1
fi

