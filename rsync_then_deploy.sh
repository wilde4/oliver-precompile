#!/bin/bash
# THIS FILE IS MEANT TO RUN ON ANY DEVELOPMENT BOX

# $2 = mode (staging or production)
# $1 = theme name

# LOGGING
exec > >(tee /cloud9/logs/all.log)
exec 2>&1

# whoami

# echo "---------------"
# echo "Starting RSYNC to $2 for $1"
# echo "---------------"

# START RSYNC OF THEME FILES TO VOLCANIC DEPLOY BOX

# ORIGINAL THEME FILES ON DEV BOX /cloud9/cloud9/theme_name
# NEED TO RSYNC TO VOLCANIC DEPLOY BOX /srv/www/volcanic_deploy/shared/themes/mode_name SO PRECOMPILE APP CAN ACCESS FILES FOR PRECOMPILE PROCESS WITH ASSET PATH /srv/www/volcanic_deploy/shared/themes/#{ENV["MODE"]}/#{ENV["THEME_NAME"]}/assets/
# rsync -arvce "ssh -o StrictHostKeyChecking=no" --delete /cloud9/cloud9/$1 deploy@46.137.112.6:/srv/www/volcanic_deploy/shared/themes/$2

echo "---------------"
echo "Starting Deploy API request to $2 for $1"
echo "---------------"

# CURL TO VOLCANIC DEPLOY API TO START DEPLOY PROCESS
curl -X POST -H "Content-Type: application/json" -d '{ "deploy": { "mode": "'"$2"'", "theme": "'"$1"'" } }' http://deploy.volcanic.co.uk/api/v1/deploys.json

echo "---------------"
echo "Finished RSYNC and Deploy API request to $2 for $1"
echo "---------------"