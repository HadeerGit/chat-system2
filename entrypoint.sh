#!/usr/bin/env bash
echo "waiting for database to start..."
echo "setting up database..."
#bin/rake db:setup && bin/rake db:migrate && bin/rake db:migrate RAILS_ENV=test
echo "starting workers..."
WORKERS=Worker bin/rake sneakers:run
echo "starting application server..."
rm -f tmp/pids/server.pid
bin/rails server -b 0.0.0.0 -p $APPLICATION_PORT