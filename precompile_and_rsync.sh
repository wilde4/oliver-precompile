#!/bin/bash

# LOGGING
exec > >(tee /cloud9/logs/all.log)
exec 2>&1

# whoami

# RUN PRECOMPILE
touch /cloud9/logs/$1.log
cd /cloud9/precompiled_assets/oliver-precompile
RAILS_ENV=production THEME_NAME=$1 MODE=$2 bundle exec rake assets:precompile > /cloud9/logs/$1.log

# COPY PRECOMPILED ASSETS TO /cloud9/sync/precompiled_assets
rm -rf /cloud9/sync/precompiled_assets/$2/$1
cp -Rf /cloud9/precompiled_assets/$1 /cloud9/sync/precompiled_assets/$2

# COPY LIQUID FILES TO /cloud9/sync/themes/staging OR /cloud9/sync/themes/production
rm -rf /cloud9/sync/themes/$2/$1
cp -Rf /cloud9/cloud9/$1 /cloud9/sync/themes/$2

# RSYNC FILES TO oliver-production STACK INSTANCES IN Rails App Server LAYER
# Instance Type: m3.large
rsync -arvce "ssh -o StrictHostKeyChecking=no" /cloud9/sync deploy@ec2-54-75-239-163.eu-west-1.compute.amazonaws.com:/srv/www/oliver/shared