#!/bin/bash

# Terminate all running bar instances
killall -q polybar

# Wait for the processes to be shut down
while pgrep -x polybar >/dev/null; do sleep 1;done

# Launch top and bottom bar
polybar top &
polybar bottom &

echo "Polybars launched"
