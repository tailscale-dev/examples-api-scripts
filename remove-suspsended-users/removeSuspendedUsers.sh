#!/bin/bash

apikey=$(cat ~/keys/api.key)
tailnet="tsjustworks.net"
targetstatus="suspended"

allusers=$(curl -s "https://api.tailscale.com/api/v2/tailnet/-/users" -u "$apikey:" || (echo "API call failed" >&2; exit 1)) 

victims=$(echo $allusers | jq -r '.users[] |select(.status == "'$targetstatus'")')
victimids=$(echo $allusers | jq -r '.users[] |select(.status == "'$targetstatus'") | .id')
v_array=($(echo "$victimids"|xargs))
if [ ${#v_array[@]} == 0 ] 
then 
    echo "No users found in state "$targetstatus", aborting"
    exit 1
fi

echo "These users are scheduled for removal. Confirm before proceding"

echo $victims |jq '"User ID: " + .loginName + "  status: " + .status'

read -p "Press [Enter] key to delete all users in the above list"

for item in "${v_array[@]}"; do 
    echo "Deleting "$item
    #Commented out the scary part. Confirm the dry run before removing the octothorpe below
    #curl -s --request POST --url https://api.tailscale.com/api/v2/users/$item/delete -u "$apikey:" || (echo "API call failed" >&2; exit 1)
done
