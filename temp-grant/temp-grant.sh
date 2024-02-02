#!/bin/bash

tailnet="tsjustworks.net"
#keys are stored in a text file under ~/keys
apikey=$(<$HOME/keys/${tailnet}.api.key)
machine=$1
duration=$2
#make it minutes (Defaults to seconds)
increment="m"

#get the nodeid from the machine name supplied on the command line
nodeid=$(curl -s "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices" -u "$apikey:" | jq -r --arg hostname $machine  '.devices[] | select(.hostname==$hostname) .id')

#set the custom attribute
curl -s "https://api.tailscale.com/api/v2/device/$nodeid/attributes/custom:prod" -u "$apikey:" --data-binary '{"value": true}' -o /dev/null
echo "Set prod to true for $duration minutes for $machine - $nodeid"

sleep ${duration}m

#unset the custom attribute
echo "Removing access from $machine after $duration minutes"
curl -s "https://api.tailscale.com/api/v2/device/$nodeid/attributes/custom:prod" -u "$apikey:" --data-binary '{"value": false}' -o /dev/null
