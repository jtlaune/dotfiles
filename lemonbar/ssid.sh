#!/bin/bash
source barcolors.sh

SSID() {
    WIFI=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2)
    WIFI="${WIFI##yes:}"
    if [ ${#WIFI} -gt 11 ]
        then
            WIFI=$(echo $WIFI | cut -c1-8)
            WIFI="${WIFI}..."
            echo $WIFI
        else
            echo $WIFI
    fi
}

while true; do
    echo -e "%{F$BG}%{B$PURPLE} \uf1eb %{F$FG}%{B$BG} $(SSID)"
    sleep 10;
done
