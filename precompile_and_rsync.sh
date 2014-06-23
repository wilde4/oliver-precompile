#!/bin/bash

# touch /cloud9/logs/$1.log
# exec > >(tee /cloud9/logs/$1.log)
# exec 2>&1

cd /cloud9/precompiled_assets/oliver-precompile
touch /cloud9/logs/$1.log
RAILS_ENV=production THEME_NAME=$1 bundle exec rake assets:precompile