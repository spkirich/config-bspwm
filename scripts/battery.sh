#! /bin/bash

# Set the battery charge and status polling interval. One poll per minute is
# good enough.

INTERVAL=60

# Set the lower and upper bounds of battery percentage. Upper bound warning
# can be disabled by setting it to more than 100 percent.

LOWER=20
UPPER=80

# Set the battery device directory. The last path component may be different
# for you.

BAT=/sys/class/power_supply/BAT1

# End of the script configuration. Then goes the script itself. Abandon hope,
# all ye who enter here!

# Maximum and current battery charge files. The paths are constructed
# relatively to the battery device directory.

MAX=$BAT/charge_full
NOW=$BAT/charge_now

# Battery status file. The path is also constructed relatively to the battery
# device directory.

STATUS=$BAT/status

while true
do
    # Read the battery status from the special file. Everything is a file,
    # even the battery status!

    s=$(cat $STATUS)

    # Read maximum and current battery charge from the special files.
    # Everything is a file! It works once again!

    m=$(cat $MAX)
    n=$(cat $NOW)

    # Calculate the battery percentage. The formula is quite straightforward,
    # isn't it?

    p=$(( 100 * $n / $m ))

    # Send a desktop notification if the battery percentage is low enough. A
    # desktop notification daemon should be running.

    if [[ $s == Discharging && $p -lt $LOWER ]]
    then
        notify-send --urgency=critical "Battery at $p%"
    fi

    # Send a desktop notification if the battery percentage is high enough. A
    # desktop notification daemon should be running.

    if [[ $s == Charging && $p -gt $UPPER ]]
    then
        notify-send --urgency=normal "Battery at $p%"
    fi

    # Sleep for a specified interval. Nothing interesting here, the script is
    # just sleeping... Zzz...

    sleep $INTERVAL
done
