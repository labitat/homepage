#!/bin/sh

set -e

show() {
  echo "+ $*"
  "$@"
}

show curl -fLo out/home_page.html --no-progress-meter https://labitat.dk/wiki/Home_page
show bin/bundle exec ruby make.rb

for src in assets/*; do
  dst="build/${src#assets/}"
  [ "$dst" -nt "$src" ] || show cp "$src" "$dst"
done
