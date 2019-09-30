#!/bin/bash
source barcolors.sh

bspc subscribe node_focus\
	| {	while read line ; do
		    WINDOWID="${line##* }"
		    WM_CLASS="$(xprop -id $WINDOWID | grep -w "WM_CLASS")"
		    WNAME="$(echo "${WM_CLASS##*=}" | cut -d \" -f2)"
		    if [ "$WNAME" = "Navigator" ]
		    then
			WNAME="$(echo "${WM_CLASS##*=}" | cut -d \" -f4)"
		    fi
		    if [ ${#WNAME} -gt 13 ]
		    then
			WNAME=$(echo $WNAME | cut -c1-10)
			WNAME="${WNAME}..."
			echo -e "%{F$BG}%{B$ORANGE} \uf2d0 %{F$FG}%{B$BG} $WNAME"
		    else
			BS=13    # buffer size
			L=$(((BS-${#WNAME})/2))
			[ $L -lt 0 ] && L=0
			WNAME=$(printf "%${L}s%s%${L}s\n" "" $WNAME "")
			echo -e "%{F$BG}%{B$ORANGE} \uf2d0 %{F$FG}%{B$BG} $WNAME"
		    fi
		done
	}
