#!/bin/bash

$HOME/desktop.sh | lemonbar -p -g 120x40+10+10 -f "Undefined Medium:size=12" -f "Font Awesome:size=10" &

#$HOME/clock.sh | lemonbar -p -g 200x40+2990+10 -f "Undefined Medium:size=12" -f "Font Awesome:size=12" &
$HOME/clock.sh | lemonbar -p -g 200x40+2988+10 -f "Undefined Medium:size=12" -f "Font Awesome:size=12" &

$HOME/battery.sh | lemonbar -p -g 200x40+2770+10 -f "Undefined Medium:size=12" -f "Font Awesome:size=11" &

$HOME/ssid.sh | lemonbar -p -g 300x40+2450+10 -f "Undefined Medium:size=12" -f "Font Awesome:size=11" &

$HOME/song.sh | lemonbar -p -g 500x40+1930+10 -f "Undefined Medium:size=12" -f "Font Awesome:size=11" &

$HOME/window.sh | lemonbar -p -g 350x40+1560+10 -f "Undefined Medium:size=12" -f "Font Awesome:size=11" &
