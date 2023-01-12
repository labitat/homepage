#!/usr/bin/env bash

set -e

curl https://labitat.dk/wiki/Home_page > out/home_page.html
ruby make.rb
cp assets/* build/
