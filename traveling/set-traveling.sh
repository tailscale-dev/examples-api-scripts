#!/bin/bash
# example run: `./set-traveling.sh jays-macbook-air false`  to disable traveling mode, 
# or ./set-traveling.sh jays-macbook-air true

# change to your tailnet name
tailnet="tsjustworks.net"

# I store my api keys in ~/keys/tsjustworks.net.api.key format
apikey=$(<$HOME/keys/${tailnet}.api.key)

machine=$1
status=$2

#get the nodeid from the machine name
nodeid=$(curl -s "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices" -u "$apikey:" | jq -r --arg hostname $machine  '.devices[] | select(.hostname==$hostname) .id')

#set the custom posture attribute
curl -s "https://api.tailscale.com/api/v2/device/$nodeid/attributes/custom:travelling" -u "$apikey:" --data-binary '{"value": "'$status'"}' -o /dev/null

output=$(curl -s "https://api.tailscale.com/api/v2/device/$nodeid/attributes" -u "$apikey:")

echo $output |jq