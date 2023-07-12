#!/bin/fish
if test (hostname) = "wolf"
    xrandr --output HDMI-0 --rotate left --mode 1920x1080 --rate 144 --output DP-0 --primary --pos 0x480 -s 3640x1440
else if (hostname) = "fennec"
    xrandr --output HDMI-1 --primary --mode 2560x1440 --rate 144
end
