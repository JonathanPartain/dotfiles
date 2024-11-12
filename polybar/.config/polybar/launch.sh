#!/usr/bin/env bash
# Terminate already running bar instances
killall -q polybar
 
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done
 

rightmost=$(xrandr --query | grep " connected" | awk '{print $1, $3}' | awk -F '[+x]' '{print $1, $3}' | sort -k2 -n | tail -1 | awk '{print $1}')

for m in $(polybar --list-monitors | cut -d":" -f1); do
  if [[ "$m" == "$rightmost" ]]; then
    MONITOR=$m polybar --reload systraybar -c ~/.config/polybar/config.ini &
  else
    MONITOR=$m polybar --reload bar -c ~/.config/polybar/config.ini &
  fi
done
