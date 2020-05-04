#!/bin/bash

# Global Variables
auth_email= # Insert cloudflare account email here
cf_api_key= # Insert global API key here
zone_id= # Insert zone ID here

# Get the current IP address
current_ip=$(curl --silent https://api.ipify.org) || exit 1

# Check if IP Record file exists
ip_record_loc="/tmp/ip-record"
if [ ! -f "$ip_record_loc" ]; then
    > /tmp/ip-record
fi

# Check if dns-entries exists and empty
[ ! -f "$PWD/dns-entries" ] && > dns-entries
[ ! -s "$PWD/dns-entries" ] && exit 0

# Get the last recorded IP address
recorded_ip=`cat $ip_record_loc`

# Compare the last recorded IP and the current IP.  If no change, then exit.
if [ "$recorded_ip" = "$current_ip" ]; then
    exit 0
fi

# Write current IP to IP Record file
echo $current_ip > $ip_record_loc
echo "IP changed to $current_ip"

# Update all entries on Cloudflare
IFS=' '
while read a_record_name a_record_id ttl proxied
do
        record=$(cat << EOF
    { "type": "A",
        "name": "$a_record_name",
        "content": "$current_ip",
        "ttl": $ttl,
        "proxied": $proxied }
EOF
    )
    curl "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$a_record_id" \
        -X PUT \
        -H "Content-Type: application/json" \
        -H "X-Auth-Email: $auth_email" \
        -H "X-Auth-Key: $cf_api_key" \
        -d "$record"
done < dns-entries