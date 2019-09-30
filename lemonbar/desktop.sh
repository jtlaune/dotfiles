#!/bin/bash
source barcolors.sh
BSPWM=$(bspc query -D)
i=0
for DESK in $BSPWM
do
    i=$(($i+1))
    declare D$i=$DESK
done

bspc subscribe desktop_focus\
	| {	while read line ; do
		    case "${line##* }" in
			$D1)
			    echo -e "%{F$BG}%{B$YELLOW} \uf108 %{F$FG}%{B$BG} 1 "
			    ;;
			$D2)
			    echo -e "%{F$BG}%{B$YELLOW} \uf108 %{F$FG}%{B$BG} 2 "
			    ;;
			$D3)
			    echo -e "%{F$BG}%{B$YELLOW} \uf108 %{F$FG}%{B$BG} 3 "
			    ;;
			$D4)
			    echo -e "%{F$BG}%{B$YELLOW} \uf108 %{F$FG}%{B$BG} 4 "
			    ;;
			$D5)
			    echo -e "%{F$BG}%{B$YELLOW} \uf108 %{F$FG}%{B$BG} 5 "
			    ;;
		    esac
		done
	}
