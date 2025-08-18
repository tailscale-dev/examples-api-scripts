This script will read the `IPPool` section of your Tailscale policy file and re-set the local iptables/nftables rules to only drop traffic to those defined ranges instead of the entire 100.64.0.0/10 range. 

It will require an OAuth client with ACL:Read scope.

To use: Define the tailnet, and the location of the OAuth client ID and Secret in the script

**note** this assumes that *all* nodes in the tailnet are scoped to an IPPool. 

**note** this needs to be run right after `tailscale up` or after each reboot. Changes do not persist.
