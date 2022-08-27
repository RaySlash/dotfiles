# Statusbar loop
    while true; do
       xsetroot -name "$( date +"%F %R" )"
       sleep 1m    # Update time every minute
    done &
# Set Wallpaper (default dir=~/Pictures)
/33211.jpg
# Set resolution on boot - All available modes (MSI OptiX)
# 2560x1440 1920x1080 1920x1080i 1024x720
xrandr --output HDMI-2 --mode 1920x1080
feh --bg-scale /home/smj/Pictures/33211.jpg
exec dwm 