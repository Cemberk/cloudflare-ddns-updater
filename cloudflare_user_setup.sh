#!/bin/bash
## change to "bin/sh" when necessary

auth_email=$AUTHEMAIL                                      # The email used to login 'https://dash.cloudflare.com'
auth_method="token"                                # Set to "global" for Global API Key or "token" for Scoped API Token 
auth_key=$GLOBALKEY                                        # Your API Token or Global API Key
zone_identifier=$ZONEID                                 # Can be found in the "Overview" tab of your domain
record_name=$RECORDNAME                                     # Which record you want to be synced
ttl="3600"                                         # Set the DNS TTL (seconds)
proxy=false                                        # Set the proxy to true or false


#setup ingress and load balancer before login so access login page to setup inf
#auth with github first on warp add cloudlfare sso integraions 
#get credentials 
cloudflared login

#get tunnel id 
cloudflared tunnel create dtunnel-k8s

#cloudflared tunnel create test
#Tunnel credentials written to /home/rimurum/.cloudflared/c971d452-4ed1-4b44-b98a-7bcc5bfa161b.json. 
#cloudflared chose this file based on where your origin certificate was found. 
#Keep this file secret. To revoke these credentials, delete the tunnel.
#
#Created tunnel test with id c971d452-4ed1-4b44-b98a-7bcc5bfa161b



export TUNNELID = ${jq '.Instances[0].ImageId' test.json
/home/$USER/.cloudflared/#get name from file 
cloudflared tunnel route dns $TUNNELID $RECORDNAME

#cloudflared proxy-dns --port 5553
