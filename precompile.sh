#!/bin/bash
# THIS FILE IS MEANT TO RUN ON THE VOLCANIC DEPLOY BOX

# LOGGING
exec > >(tee /srv/www/volcanic_deploy/shared/system/logs/$2/$1-$3.log)
exec 2>&1

# whoami

echo "---------------"
echo "Starting Deploy to $2 for $1"
echo "---------------"

# ORIGINAL THEME FILES ON DEV BOX /cloud9/cloud9/theme_name
# NEED TO RSYNC TO VOLCANIC DEPLOY BOX /srv/www/volcanic_deploy/shared/themes/mode_name SO PRECOMPILE APP CAN ACCESS FILES FOR PRECOMPILE PROCESS WITH ASSET PATH /srv/www/volcanic_deploy/shared/themes/#{ENV["MODE"]}/#{ENV["THEME_NAME"]}/assets/
# rsync -arvce "ssh -o StrictHostKeyChecking=no" --delete deploy@54.75.232.48:/cloud9/cloud9/$1 /srv/www/volcanic_deploy/shared/themes/$2
rsync -arvce "ssh -o StrictHostKeyChecking=no" --delete deploy@10.0.1.200:/cloud9/cloud9/$1 /srv/www/volcanic_deploy/shared/themes/$2

# RUN PRECOMPILE
cd /srv/www/precompile_app/current
RAILS_ENV=production THEME_NAME=$1 MODE=$2 bundle exec rake assets:clean
RAILS_ENV=production THEME_NAME=$1 MODE=$2 bundle exec rake assets:precompile

# COPY PRECOMPILED ASSETS TO /deploy_themes/precompiled_assets
rm -rf /deploy_themes/precompiled_assets/$2/$1
cp -Rf /srv/www/precompile_app/current/public/$2/$1 /deploy_themes/precompiled_assets/$2

# COPY LIQUID FILES TO /deploy_themes/themes/staging OR /deploy_themes/themes/production
rm -rf /deploy_themes/themes/$2/$1
cp -Rf /srv/www/volcanic_deploy/shared/themes/$2/$1 /deploy_themes/themes/$2

# RSYNC TO PUBLIC_DNS LIST
IFS=','
for dns in $4
do
  rsync -arvce "ssh -o StrictHostKeyChecking=no" --delete /deploy_themes/precompiled_assets/$2/$1 deploy@$dns:/srv/www/oliver/shared/sync/precompiled_assets/$2
  rsync -arvce "ssh -o StrictHostKeyChecking=no" --delete /deploy_themes/themes/$2/$1 deploy@$dns:/srv/www/oliver/shared/sync/themes/$2
done

# s3cmd PUSH TO S3 BUCKET
s3cmd sync --recursive --delete-removed /deploy_themes/precompiled_assets/$2/$1/ s3://oliver-themes/precompiled_assets/$2/$1/ >/tmp/s3_put_errors.txt
s3cmd sync --recursive --delete-removed /deploy_themes/themes/$2/$1/ s3://oliver-themes/themes/$2/$1/ >/tmp/s3_put_errors.txt

echo "---------------"
echo "Finished Deploy to $2 for $1"
echo "---------------"

# POST TO DEPLOY API TO UPDATE LOG RECORD
curl -s -X PATCH -H "Content-Type: application/json" -d '{ "deploy": { "log_url": "/srv/www/volcanic_deploy/shared/system/logs/'"$2"'/'"$1"'-'"$3"'.log" } }' http://deploy.volcanic.co.uk/api/v1/deploys/$3.json

# POST TO EU OLIVER API TO UPDATE SITE CACHE
curl -X PUT -H "Content-Type: application/json" -d '{"theme_name": "'"$1"'"}' https://www.volcanic.co.uk/api/v1/metacontents/update_timestamps.json
