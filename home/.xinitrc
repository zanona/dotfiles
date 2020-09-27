# Adjust keyboard typematic delay and rate
xset r rate 270 30

# DISPLAY_DPI declared locally on /etc/environment
# https://wiki.archlinux.org/index.php/Environment_variables
xrandr --dpi "$DISPLAY_DPI"

xrdb -DDISPLAY_DPI="$DISPLAY_DPI" -merge "$HOME/.Xresources"

# exec xterm -geometry 142x42+20+20

# Let QT autodetect retina screen and autoadjust
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Use OSX keyboard bindings for accents
setxkbmap us mac

# apply .Xmodmap for vim style navigation
xmodmap ~/.Xmodmap

#feh --no-fehbg --bg-fill ~/tmp/bg.jpg
xscreensaver &
unclutter &
dwmbar &
bash -c "trap 'killall xscreensaver unclutter dwmbar' EXIT; dwm"
