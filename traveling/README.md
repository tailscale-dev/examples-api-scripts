Using device posture to manage access for traveling employees. 

Device posture is a powerful tool to control Tailscale permissions and access to devices on your network. They extend our ACL capabilities and allow admins to use fine-grained controls that can be based on some properties on the device, or custom attributes which can be set through automation tools. 

Postures can be changed independently via the API per device, without having to change the ACL. They are ideal for modifying access temporarily or in rapidly changing scenarios. 

In this scenario, we want to restrict access to internal resources while an employee is traveling, while still allowing them to secure their internet access with exit nodes or Mullvad exit nodes. 

This could be used in conjunction with MDM policies which force exit nodes and force Tailscale to stay connected. 

This script can toggle the “traveling” custom attribute: 

```
#!/bin/bash
# example run: `./set-traveling.sh jays-macbook-air false`  to disable traveling mode, 
# or ./set-traveling.sh jays-macbook-air true

# change to your tailnet name
tailnet="tsjustworks.net"

# I store my api keys in ~/jay/keys/tsjustworks.net.api.key format
apikey=$(<$HOME/keys/${tailnet}.api.key)

machine=$1
status=$2

#get the nodeid from the machine name
nodeid=$(curl -s "https://api.tailscale.com/api/v2/tailnet/$tailnet/devices" -u "$apikey:" | jq -r --arg hostname $machine  '.devices[] | select(.hostname==$hostname) .id')

#set the custom posture attribute
curl -s "https://api.tailscale.com/api/v2/device/$nodeid/attributes/custom:travelling" -u "$apikey:" --data-binary '{"value": "'$status'"}' -o /dev/null

output=$(curl -s "https://api.tailscale.com/api/v2/device/$nodeid/attributes" -u "$apikey:")

echo $output |jq
```

And this posture would require that custom:traveling be set to false

```
"postures": {
    "posture:not-traveling": [
        "custom:traveling == false",
    ],
},
```

If you want this to be applied to all connections, without modifying the ACL policies, you can use the defaultSrcPosture section: 


```
"defaultSrcPosture": [
    “posture:not-traveling”
],
```


Otherwise, if there are some resources you still want travelers to use, you can reference the posture directly in the ACLs as such:

```
"acls": [
    {
        // Machines only have access to dev resources when not traveling
        "action": "accept",
        "src": ["autogroup:member"],
        "dst": ["tag:development"],
        "srcPosture": ["posture:not-traveling"]
    },
    {
        // People should be able to submit a help desk ticket even when traveling
        "action": "accept",
        "src": ["autogroup:member"],
        "dst": ["tag:ticketing"],
    },
    {
        // Anyone can access exit nodes whether or not they’re traveling
        "action": "accept",
        "src": ["autogroup:member"],
        "dst": ["autogroup:internet"],
    },
],
```