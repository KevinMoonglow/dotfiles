#!/bin/bash

set +e

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
dunst &
awww-daemon &
waybar -c ~/.config/waybar/config-fennec-mango &

