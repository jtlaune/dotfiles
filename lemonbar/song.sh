#!/bin/bash
source barcolors.sh

Song() {
    spotifyid=$(ps -ef | grep 'spotify' | awk '{print $2}' | head -1)

    currentsong=$(wmctrl -l -p | grep $spotifyid | sed -n 's/.*'$HOSTNAME'//p');

    if [ "$currentsong" = "" ]; then
	TITLE="no jams";
    elif [ "$(echo $currentsong)" == 'Spotify' ]; then
	TITLE="paused";
    else
	SONG="${currentsong##*-}"
	ARTIST="${currentsong%%-*}"
	TITLE="$SONG - $ARTIST"
    fi
    if [ ${#TITLE} -gt 22 ]
        then
            TITLE=$(echo $TITLE | cut -c1-19)
            TITLE="${TITLE}..."
            echo $TITLE
        else
	    BS=22    # buffer size
	    L=$(((BS-${#TITLE})/2))
	    [ $L -lt 0 ] && L=0
	    TITLE=$(printf "%${L}s%s%${L}s\n" "" "$TITLE" "")
	    echo "$TITLE"
    fi
    
}

while true; do
    echo -e "%{F$BG}%{B$GREEN} \uf001 %{F$FG}%{B$BG} $(Song)"
    sleep 5;
done
