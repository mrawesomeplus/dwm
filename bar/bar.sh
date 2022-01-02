#!/bin/dash

interval=0

# load colors!
. $HOME/.local/share/dwm/bar/themes/dracula

cpu() {
	cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

	printf "^c$black^ ^b$green^ CPU"
	printf "^c$white^ $cpu_val"
}


pkg_updates() {
	updates=$(xbps-install -un | wc -l)

	printf "^c$green^  $updates"" updates"
}

battery() {
	get_capacity=$(cat /sys/class/power_supply/BAT1/capacity)
	printf "^c$cyan^   $get_capacity"
}

mem() {
	printf "^c$cyan^ ^b$black^  "
	printf "^c$cyan^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$cyan^  ^d^%s" " ^c$blue^$(iw dev | grep -i ssid | awk '{ print $2 }')" ;;
	down) printf "^c$black^ ^b$cyan^  ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$blue^  "
	printf "^c$black^ ^b$cyan^ $(date '+%I:%M %p') "
}

while true; do

	#[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
	#interval=$((interval + 1))
	
	sleep 1 && xsetroot -name "$updates $(battery) $(wlan) $(cpu) $(mem) $(clock)"
done
