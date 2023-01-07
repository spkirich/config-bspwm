#! /bin/sh

INTERVAL=60

LOWER=20
UPPER=80

BAT=/sys/class/power_supply/BAT1

MAX=$BAT/charge_full
NOW=$BAT/charge_now

STATUS=$BAT/status

while true
do
    s=$(cat $STATUS)

    m=$(cat $MAX)
    n=$(cat $NOW)

    p=$(( 100 * $n / $m ))

    if [[ $s == Discharging && $p -lt $LOWER ]]
    then
        notify-send --urgency=critical "Battery at $p%"
    fi

    if [[ $s == Charging && $p -gt $UPPER ]]
    then
        notify-send --urgency=normal "Battery at $p%"
    fi

    sleep $INTERVAL
done
