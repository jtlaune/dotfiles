#!/bin/bash
source barcolors.sh

# Define the clock
Clock() {
        DATETIME=$(date "+%H:%M")

        echo -n "$DATETIME"
}

# Print the clock

while true; do
        echo -e "%{F$BG}%{B$AQUA} \uf017 %{F$FG}%{B$BG} $(Clock) "
        sleep 5
done
