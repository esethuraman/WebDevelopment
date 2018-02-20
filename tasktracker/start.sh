#!/bin/bash

export PORT=5109

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start

