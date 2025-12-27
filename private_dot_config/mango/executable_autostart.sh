#!/bin/bash

set +e

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
dunst &
swww-daemon &
waybar -c ~/.config/waybar/config-fennec-mango &

