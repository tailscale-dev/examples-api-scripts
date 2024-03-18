#Delete Old Nodes  
This will clean out nodes which have not been seen longer than the value of `$oldenough` - I've set this to one month.

I keep my api key in ~/keys/tailnetname.api.key - if you have them elsewhere, you should change the `$apikey` value.

And set `$tailnet` to the domain of your tailnet. 

This will do a dry-run as is, and print the ID of the node it will delete. Uncomment the DELETE command to execute. 
