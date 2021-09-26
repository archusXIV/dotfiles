#!/bin/sh

# This little script let you choose any man-page installed on your computer
# and then pipe it into zathura pdf reader

rc="$HOME/.config/dmenu/dmenurc"

[ -f "$rc" ] && . "$rc"

man -k . | dmenu -l 30 $DMENU_OPTIONS | awk '{print $1}' | xargs -r man -Tpdf | zathura -
