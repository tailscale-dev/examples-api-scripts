#!/bin/bash

tailnet="tsjustworks.net"
CIDRs=()
pools=()
oauthId=$(cat ~/keys/$tailnet.policy.oauth.id)
oauthSecret=$(cat ~/keys/$tailnet.policy.oauth.secret)
apikey=$(curl -d "client_id=$oauthId" -d "client_secret=$oauthSecret" -sSL https://api.tailscale.com/api/v2/oauth/token |jq -r .access_token)

#get defined pools
declare -a pools=$(curl -sSL https://api.tailscale.com/api/v2/tailnet/$tailnet/acl --header "Authorization: Bearer $apikey" |grep -i ippool)
IFS=","
for CIDR in ${pools}; do
  CIDRs+=$(echo $CIDR |cut -d [ -f 2 |sed -e 's/\]//' -e 's/\"/\ /g' -e '/^\s*$/d')
done

#remove default routing DROP
iptables -D ts-input ! -i tailscale0 -s 100.64.0.0/10 -j DROP

#add in more specific DROP rules
IFS=" "
for CIDR in ${CIDRs}; do
  iptables --insert ts-input 3 ! -i tailscale0 -s $CIDR -j DROP
done

#show new state
iptables -L ts-input -v
