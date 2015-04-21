#!/bin/bash

# LOGGING
exec > >(tee /srv/www/oliver-precompile/shared/logs/precompile.log)
exec 2>&1

# whoami

# RUN PRECOMPILE
cd /srv/www/oliver-precompile/current
RAILS_ENV=production THEME_NAME=$1 MODE=$2 bundle exec rake assets:clean
RAILS_ENV=production THEME_NAME=$1 MODE=$2 bundle exec rake assets:precompile

# COPY PRECOMPILED ASSETS TO /srv/sync/precompiled_assets
rm -rf /srv/sync/precompiled_assets/$2/$1
cp -Rf /srv/www/oliver-precompile/public/$2/$1 /srv/sync/precompiled_assets/$2

# COPY LIQUID FILES TO /srv/sync/themes/staging OR /srv/sync/themes/production
rm -rf /srv/sync/themes/$2/$1
cp -Rf /srv/www/oliver-precompile/shared/themes/$1 /srv/sync/themes/$2