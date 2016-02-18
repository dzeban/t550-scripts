#!/bin/bash -eu

LOGGER="logger -t $0"
N_MONITORS=0

function get_monitors_count()
{
    echo $(xrandr -q | grep " connected" | wc -l )
}

# Apply configuration depending on monitors count
function apply_configuration()
{
    local n=$1

    if [[ ! -x /etc/layout/$n.sh ]]; then
        $LOGGER "No configuration for $n monitors, create it with `arandr` and save it to /etc/layout"
        exit 1
    fi

    $LOGGER "Applying configuration for $n monitors"
    /etc/layout/$n.sh
}

# Determine configuration changes, exactly monitor count changes.
# Uses and updates N_MONITORS
# Return 0 if not changed, 1 if changed
function changed_configuration()
{
    local n=$(get_monitors_count)
    if [[ "$n" -ne "$N_MONITORS" ]]; then
        N_MONITORS="$n"
        return 0
    else
        return 1
    fi
}

export DISPLAY=:0

# Upon receiving event from kernel we apply configuration and 
# keep polling for the new state for 10 more seconds.
# We have to do this, because monitors don't appear immediately in xrandr
# on cable plug/unplug, e.g. DisplayPort devices may take more than 
# 5 seconds to appear. So xrandr reports old configuration.
N_MONITORS=$(get_monitors_count)
apply_configuration $N_MONITORS

seconds=20 # Sigh...
while ((seconds > 0)); do
    if changed_configuration; then
        apply_configuration $N_MONITORS
		break
    fi
    sleep 1
    seconds=$((seconds-1))
done

# vim: ts=4: sw=4: expandtab
