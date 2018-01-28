#!/bin/bash

export PORT=4002

cd ~/www/memory
./bin/memory stop || true
./bin/memory start

