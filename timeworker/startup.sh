#!/bin/bash

cd /opt/app
bundle install
rake db:migrate
rm -rf /opt/app/tmp/pids/server.pid
rails server -b 0.0.0.0
