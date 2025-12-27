#!/bin/fish
if test (hostname) = "wolf"
    xrandr --output HDMI-0 --rotate left --mode 1920x1080 --rate 144 --output DP-0 --primary --pos 0x480 -s 3640x1440
else if test (hostname) = "fennec"
    #xrandr --output DP-0 --rotate left --mode 1920x1080 --rate 144 --pos 2560x0 --output HDMI-0 --primary --mode 2560x1440 --pos 0x480 -s 3640x1440

	#xrandr --output DP-2 --rotate left --mode 1920x1080 --rate 144 --pos 2560x0 --output DP-0 --primary --mode 2560x1440 --pos 0x480 -s 3640x1440
	xrandr --output DP-2 --rotate normal --mode 1920x1080 --rate 144 --pos 2560x180 --output DP-0 --primary --mode 2560x1440 --pos 0x0 -s 3640x1440
end
