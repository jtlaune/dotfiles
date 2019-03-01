# ~/.config/openbox/autostart.sh
#
# Run these programs when openbox starts.

# lock screen on suspend
xss-lock -- /usr/local/bin/slock &

# dropbox daemon
dropbox start &

# set the background
feh --bg-fill ~/.wallpapers/dark-green-foliage.jpg &

# tint2
tint2 -c ~/.config/tint2/tint2rc &
