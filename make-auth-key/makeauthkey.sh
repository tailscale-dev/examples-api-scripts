#!/bin/bash

tailnet="tsjustworks.net"
#read oauth client from files
oauthsecret=$(<$HOME/keys/${tailnet}.oauth.secret)
oauthid=$(<$HOME/keys/${tailnet}.oauth.id)
#tag needs to be supported by the oauth client
tag="tag:nothing"

#generate api key from oauth client
apikey=$(curl -sd "client_id=$oauthid" -d "client_secret=$oauthsecret" \
     "https://api.tailscale.com/api/v2/oauth/token" |jq -j '.access_token' )

#generate auth key with api key
authkey=$(curl -su $apikey: "https://api.tailscale.com/api/v2/tailnet/$tailnet/keys" \
  --data-binary '
{
  "capabilities": {
    "devices": {
      "create": {
        "reusable": false,
        "ephemeral": false,
        "preauthorized": false,
        "tags": [ "'$tag'" ]
      }
    }
  },
  "expirySeconds": 86400,
  "description": "test"
}'
)

echo $authkey |jq