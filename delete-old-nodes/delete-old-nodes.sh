#!/bin/bash

tailnet="tailnetname.com"
apikey=$(<$HOME/keys/${tailnet}.api.key)
oldenough=$(date -I --date="1 month ago")

curl -s "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices" -u "$apikey:" |jq -r '.devices[] |  "\(.lastSeen) \(.id)"' |
  while read seen id; do
		if [[ $seen < $oldenough ]]
		then
			echo $id " was last seen " $seen " getting rid of it"
   			### Uncomment below line to execute script. Defaults to dry run.
			#curl -s -X DELETE "https://api.tailscale.com/api/v2/device/$id" -u "$apikey:"
		else
			echo $id " was last seen " $seen " keeping it"
		fi
	done
