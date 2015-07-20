#!/bin/bash
# THIS FILE IS MEANT TO RUN ON THE VOLCANIC DEPLOY BOX

# LOGGING
exec > >(tee /srv/www/volcanic_deploy/shared/system/logs/$2/$1.log)
exec 2>&1

# whoami

echo "---------------"
echo "Starting Deploy to $2 for $1"
echo "---------------"

# RUN PRECOMPILE
cd /srv/www/precompile_app/current
RAILS_ENV=production THEME_NAME=$1 MODE=$2 bundle exec rake assets:clean
RAILS_ENV=production THEME_NAME=$1 MODE=$2 bundle exec rake assets:precompile

# COPY PRECOMPILED ASSETS TO /srv/sync/precompiled_assets
rm -rf /srv/www/precompile_app/shared/sync/precompiled_assets/$2/$1
cp -Rf /srv/www/precompile_app/current/public/$2/$1 /srv/www/precompile_app/shared/sync/precompiled_assets/$2

# COPY LIQUID FILES TO /srv/www/precompile_app/shared/sync/themes/staging OR /srv/www/precompile_app/shared/sync/themes/production
rm -rf /srv/www/precompile_app/shared/sync/themes/$2/$1
cp -Rf /srv/www/volcanic_deploy/shared/themes/$1 /srv/www/precompile_app/shared/sync/themes/$2/$1

# RSYNC TO PUBLIC_DNS LIST
IFS=','
for dns in $4
do
  # echo "public_dns = $dns"
  # rsync -arvce "ssh -o StrictHostKeyChecking=no" /cloud9/sync deploy@$dns:/srv/www/oliver/shared

  rsync -arvce "ssh -o StrictHostKeyChecking=no" /srv/www/precompile_app/shared/sync/precompiled_assets/$2/$1 deploy@$dns:/srv/www/oliver/shared/sync/precompiled_assets/$2
  rsync -arvce "ssh -o StrictHostKeyChecking=no" /srv/www/precompile_app/shared/sync/themes/$2/$1 deploy@$dns:/srv/www/oliver/shared/sync/themes/$2
done

echo "---------------"
echo "Finished Deploy to $2 for $1"
echo "---------------"

# POST TO DEPLOY API TO UPDATE LOG RECORD
curl -s -X PATCH -H "Content-Type: application/json" -d '{ "deploy": { "log_url": "/srv/www/volcanic_deploy/shared/system/logs/'"$2"'/'"$1"'.log" } }' http://deploy.volcanic.co.uk/api/v1/deploys/$3.json