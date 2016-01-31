#!/usr/bin/bash

[[ -f screen.png ]] || ln -s /tmp/screen.png
[[ -f commands ]] || mkfifo commands

./adb-shell &
./capture &
love .
pkill capture
