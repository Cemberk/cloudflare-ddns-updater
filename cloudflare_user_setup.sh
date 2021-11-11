#!/bin/bash
## change to "bin/sh" when necessary

auth_email=$AUTHEMAIL                                      # The email used to login 'https://dash.cloudflare.com'
auth_method="token"                                # Set to "global" for Global API Key or "token" for Scoped API Token 
auth_key=$GLOBALKEY                                        # Your API Token or Global API Key
zone_identifier=$ZONEID                                 # Can be found in the "Overview" tab of your domain
record_name=$RECORDNAME                                     # Which record you want to be synced
ttl="3600"                                         # Set the DNS TTL (seconds)


#setup ingress and load balancer before login so access login page to setup inf
#auth with github first on warp add cloudlfare sso integraions 

#get credentials 
output=$(cloudflared login)
IFS = ' '
#Read the split words into an array based on space delimiter
read -a strarr <<< "$output"

export TUNNELID = ${strarr[15]}
kubectl create secret generic cloudflare-cred --from-file=cloudflare-credentials.json=$TUNNELID



#get tunnel id 
output=$(cloudflared tunnel create dtunnel-k8s)
IFS=' '
#Read the split words into an array based on space delimiter
read -a strarr <<< "$output"

export TUNNELPATH=${strarr[4]::-1}
kubectl create secret generic tunnel-cred --from-file=tunnel-credentials.json=$TUNNELPATH

cloudflared tunnel route dns $TUNNELID $RECORDNAME


#TODO add to bootstrap cloudflared proxy-dns --port 5553









#cloudflared tunnel create test
#Tunnel credentials written to /home/rimurum/.cloudflared/c971d452-4ed1-4b44-b98a-7bcc5bfa161b.json. 
#cloudflared chose this file based on where your origin certificate was found. 
#Keep this file secret. To revoke these credentials, delete the tunnel.
#
#Created tunnel test with id c971d452-4ed1-4b44-b98a-7bcc5bfa161b

#add to bash variable 
#8447ac9e-3ad1-456d-a284-d54a5b4b9754.json:1:{"AccountTag":"4df94305e0eeb0ac9663f14c98659d07","TunnelSecret":"iKF42ucwRSUbwZMQlsWYzQJcO1OhuogWdUnkRNp6tus=","TunnelID":"8447ac9e-3ad1-456d-a284-d54a5b4b9754","TunnelName":"dtunnel-k8s"}
#c971d452-4ed1-4b44-b98a-7bcc5bfa161b.json:1:{"AccountTag":"4df94305e0eeb0ac9663f14c98659d07","TunnelSecret":"0axh3SYMIXF1tC0NQJJSIbrtQETxe5FAZBNxYqS9AH4=","TunnelID":"c971d452-4ed1-4b44-b98a-7bcc5bfa161b","TunnelName":"test"}
#tunnel = ${grep -inr --include \*.json .}

# Set space as the delimiter
#IFS='.'

#Read the split words into an array based on space delimiter
#read -a strarr <<< "$tunnel"

#export TUNNELID = ${strarr[0]}

#cloudflared tunnel route dns $TUNNELID $RECORDNAME
#get credentials and login and export to cluster then on container start proxy

#cloudflared proxy-dns --port 5553
#add this script as start in cloudflared cluster 
#automate login to cloudflare first then move credentials 
#3 way handshake credentials when auth when docker is ready send request back to ask for login 

#Count the total words
#echo "There are ${#strarr[*]} words in the text."

#${jq '.Instances[0].ImageId' test.json}
#/home/$USER/.cloudflared/#get name from file 
#cloudflared tunnel route dns $TUNNELID $RECORDNAME

