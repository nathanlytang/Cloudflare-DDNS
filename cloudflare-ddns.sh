#!/bin/sh

# Global Variables
auth_email= # Insert cloudflare account email here
cf_api_key= # Insert global API key here
zone_id= # Insert zone ID here

# Get the last recorded IP and the current IP
recorded_ip=`cat $PWD/ip-record`
current_ip=$(curl --silent https://api.ipify.org) || exit 1

# Compare the last recorded IP and the current IP.  If no change, then exit.
if [ "$recorded_ip" = "$current_ip" ]; then
    echo $recorded_ip
    echo $current_ip
    exit 0
fi

echo $current_ip > ip-record

echo "IP changed to $current_ip"

INPUT=ddns-entries