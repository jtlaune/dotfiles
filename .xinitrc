#!/bin/sh

# ~/.xinitrc

xrdb ~/.Xresources 

# map caps lock to escape
setxkbmap -option caps:escape
setxkbmap -option altwin:swap_lalt_lwin

# wallpaper
feh --bg-fill ~/.wallpapers/flowercity.jpg

# X settings
xset +fp ~/.fonts
xset fp rehash
xsetroot -cursor_name left_ptr
xss-lock -- /usr/local/bin/lockscreen & 
# this allows systemd to access X server for gnome-keyring
#dbus-update-activation-environment --systemd DISPLAY

# other programs
compton &
dunst &
dropbox start &
#sxhkd &
#exec bspwm
#exec i3
#exec awesome
exec herbstluftwm
