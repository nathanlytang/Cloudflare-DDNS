<p align="center">
    <a href="https://github.com/nathanlytang/cloudflare-ddns" alt="Repo Size">
        <img src="https://img.shields.io/github/repo-size/nathanlytang/cloudflare-ddns" /></a>
    <a href="https://github.com/nathanlytang/cloudflare-ddns" alt="License">
        <img src="https://img.shields.io/github/license/nathanlytang/cloudflare-ddns" /></a>
    <a href="https://github.com/nathanlytang/cloudflare-ddns" alt="Language">
	<img src="https://img.shields.io/github/languages/top/nathanlytang/cloudflare-ddns" /></a>
</p>


# Cloudflare-DDNS

Cloudflare-DDNS is a dynamic DNS client to automatically update Cloudflare's DNS service as your public IP address changes using Cloudflare's API v4 -- no need for a third party dynamic DNS service.  The client will run in most shells, and is best suited to run as a cron job.

## Features

* Easy entry management.  All your records are placed in one file, making it easy to see what is being updated.
* Update multiple records at once.  By placing all your records in one file, you only have to run the service once to update all your entries.

## Setup

1. Install the script
    `
    curl https://raw.githubusercontent.com/nathanlytang/Cloudflare-DDNS/master/cloudflare-ddns.sh >> /** PATH TO FILE **/cloudflare-ddns/cloudflare-ddns.sh
    `


2. Change directory and enable execution permissions
    `
    chmod +x /** PATH TO FILE **/cloudflare-ddns.sh
    `


3.  In the client file, input your Cloudflare account email, API key, and Zone ID in the *Global Variables* section

    ```bash
    # Global Variables
    auth_email= # Insert Cloudflare account email here
    cf_api_key= # Insert global API key here
    zone_id= # Insert zone ID here
    ip_record_loc="/tmp/ip-record" # Location of ip records file
    dns_entries_loc="/srv/cloudflare-ddns/dns-entries" # Location of dns entries file
    ```

    * The zone ID can be found on your Cloudflare dashboard, and your API key can be found in your profile.
    * You may also wish to change the location of your dns entries and IP records files: you can do so here.


4.  Get your A-record ID's
    * Use your zone ID, Cloudflare account email, and account API key
    `
    curl -X GET "https://api.cloudflare.com/client/v4/zones/** ZONE ID **/dns_records?type=A" -H "X-Auth-Email: ** Cloudflare account email **" -H "X-Auth-Key: ** API KEY **" -H "Content-Type: application/json"
    `


5.  Create a new file called `dns-entries` in the same directory and place each entry on a new line.  
    * In each entry, list the A-Record Name, A-Record ID, TTL, and Proxied, each separated by a single space.

    Eg.
    > A-record-name A-record-ID TTL Proxied
    > ```
    > www abcdefghijklmnopqrstuvwxyz 300 true
    > root 1234567890abcdefghijklmnop 180 false
	> ```

6.  Set up the client to run automatically with cron.
    `
    crontab -e
    `

    Eg. Set the client to check for IP updates every 5 minutes
    > `*/5 * * * * /** PATH TO FILE **/cloudflare-ddns/cloudflare-ddns.sh`

7.  You're done!  To test if your client is working, delete the IP records file and change your records to something random in the Cloudflare dashboard.  When the client is next run, your records will be matched with your current IP.

## Multiple Domains

Use `cloudflare-multi-ddns.sh`.  Rather than having the authentication email, API key, and zone id specified by the script, they are stored in the `dns-entries` file.
Your `dns-entries` file will look like this:
    * In each entry, list the Auth_email, api_key, zone_id, A-Record Name, A-Record ID, TTL, and Proxied, each separated by a single space.

Eg.
> Auth_email Api_key Zone_id A-record-name A-record-ID TTL Proxied
> ```
> example@email.com cf_api_key_here zone_id_here www a_record_id_here 300 true
> differentemail@email.com different_cf_api_key_here different_zone_id_here @ a_record_id_here 180 false
> ```

## Notes
* Do not share your API key.  Anyone who has it can make changes to your account.
