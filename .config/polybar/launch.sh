#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

if [[ "$(hostname)" == "wolf" ]]; then
	MONITOR=DP-0 polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
	MONITOR=HDMI-0 polybar side 2>&1 | tee -a /tmp/polybar2.log & disown
elif [[ "$(hostname)" == "fennec" ]]; then
	MONITOR=HDMI-0 polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
	MONITOR=DP-0 polybar side 2>&1 | tee -a /tmp/polybar2.log & disown
fi

echo "Bars launched..."
