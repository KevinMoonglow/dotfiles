#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

lbar=main
rbar=side


if [[ "$DESKTOP_SESSION" == "hyprland" ]]; then
	lbar=main_hypr
	rbar=side_hypr
fi

if [[ "$(hostname)" == "wolf" ]]; then
	MONITOR=DP-0 polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
	MONITOR=HDMI-0 polybar side 2>&1 | tee -a /tmp/polybar2.log & disown
elif [[ "$(hostname)" == "fennec" ]]; then
	if [[ -z "$WAYLAND_DISPLAY" ]]; then
		MONITOR=DP-0 polybar $lbar 2>&1 | tee -a /tmp/polybar1.log & disown
		MONITOR=DP-2 polybar $rbar 2>&1 | tee -a /tmp/polybar2.log & disown
	else
		MONITOR=DP-1 polybar $lbar 2>&1 | tee -a /tmp/polybar1.log & disown
		MONITOR=DP-3 polybar $rbar 2>&1 | tee -a /tmp/polybar2.log & disown
	fi
fi

echo "Bars launched..."
