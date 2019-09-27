#!bin/sh

rm -f tmp/pids/server.pid
rails s -b 0.0.0.0
