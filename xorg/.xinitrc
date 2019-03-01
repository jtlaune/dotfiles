#!/bin/sh

# ~/.xinitrc

setxkbmap -option caps:escape
xrdb ~/.Xresources 
feh --bg-fill ~/.wallpapers/dark-green-foliage.jpg 
exec openbox-session 
