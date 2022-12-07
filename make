#!/usr/bin/env bash

set -e

curl https://labitat.dk/wiki/Home_page > home_page.html
mkdir -p build
ruby make.rb
cp assets/* build/
