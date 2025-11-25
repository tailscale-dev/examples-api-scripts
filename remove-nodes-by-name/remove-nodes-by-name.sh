#!/bin/bash

tailnet="tsjustworks.net"
apikey=$(<$HOME/keys/${tailnet}.api.key)
targetname="ephemeral-test-"

curl -s "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices" -u "$apikey:" |jq -r '.devices[] |  "\(.id) \(.name)"' |
  while read id name; do
		if [[ $name = *"$targetname"* ]]
		then
			echo $name $id " includes " $name " in its name - getting rid of it"
			#curl -s -X DELETE "https://api.tailscale.com/api/v2/device/$id" -u "$apikey:"
		else
			echo $name" does not have that string in its name, keeping it"
		fi
	done
