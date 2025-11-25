#Delete Nodes By Name
This will delete any nodes on your tailnet that match a string in their device name. I've used it to clean up after several instances were created by a runaway script.

I keep my api key in ~/keys/tailnetname.api.key - if you have them elsewhere, you should change the `$apikey` value.

And set `$tailnet` to the domain of your tailnet. 

This will do a dry-run as is, and print the ID of the node it will delete. Uncomment the DELETE command to execute. 
