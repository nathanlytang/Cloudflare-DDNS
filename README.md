# Cloudflare-DDNS

Cloudflare-DDNS is a dynamic DNS client to automatically update Cloudflare's DNS service as your public IP address changes using Cloudflare's API v4, no need for a third party DDNS service.  The client will run in most shells, and is best suited to run as a cron job.

## Features

* Easy entry management.  All your records are placed in one file, making it easy to see what is being updated.
* Update multiple records at once.  By placing all your records in one file, you only have to run the service once to update all your entries.

## Setup

1. Install the script

    `curl https://raw.githubusercontent.com/nathanlytang/Cloudflare-DDNS/master/cloudflare-ddns.sh >> /srv/cloudflare-ddns/cloudflare-ddns.sh`

2. Change directory and enable execution permissions

    `cd /srv/cloudflare-ddns`
    `chmod +x clouflare-ddns.sh`

3.  Input your Cloudflare account email, API key, and Zone ID in the *Global Variables* section

    `nano cloudflare-ddns.sh`

    ![Global variables]( https://github.com/nathanlytang/Cloudflare-DDNS/blob/master/images/global_variables.png "Global variables")


