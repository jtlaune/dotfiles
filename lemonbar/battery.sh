#!/bin/bash
source barcolors.sh

Battery() {
        BATPERC=$(acpi --battery | cut -d, -f2)
        echo "$BATPERC"
}

# Print the percentage
while true; do
        echo -e "%{F$BG}%{B$RED} \uf240 %{F$FG}%{B$BG}$(Battery) "
        sleep 10;
done
