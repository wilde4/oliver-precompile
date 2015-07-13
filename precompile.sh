#!/bin/bash

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

echo "---------------"
echo "Finished Deploy to $2 for $1"
echo "---------------"

# POST TO DEPLOY API TO UPDATE LOG RECORD
log = `cat /srv/www/volcanic_deploy/shared/system/logs/$2/$1.log`
curl -X PATCH -H "Content-Type: application/json" -d '{ "deploy": { "log": "&log" } }' http://www.localhost.volcanic.co:3001/api/v1/deploys/$3.json