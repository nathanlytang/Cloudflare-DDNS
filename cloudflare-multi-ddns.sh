#!/bin/bash

# Global Variables
ip_record_loc="/tmp/ip-record" # Location of ip records file
dns_entries_loc="/srv/cloudflare-ddns/dns-entries" # Location of dns entries file

# Get the current IP address
current_ip=$(curl --silent https://api.ipify.org) || exit 1

# Check if IP Record file exists
if [ ! -f "$ip_record_loc" ]; then
    > $ip_record_loc
fi

# Check if dns-entries exists and empty
[ ! -f "$dns_entries_loc" ] && > $dns_entries_loc
[ ! -s "$dns_entries_loc" ] && exit 0

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
while read auth_email cf_api_key zone_id a_record_name a_record_id ttl proxied
do
        record=$(cat << EOF
    { "type": "A",
        "name": "$a_record_name",
        "content": "$current_ip",
        "ttl": $ttl,
        "proxied": $proxied }
EOF
    )
    curl --silent "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$a_record_id" \
        -X PUT \
        -H "Content-Type: application/json" \
        -H "X-Auth-Email: $auth_email" \
        -H "X-Auth-Key: $cf_api_key" \
        -d "$record"
done < $dns_entries_loc