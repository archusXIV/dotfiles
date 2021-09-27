#!/bin/sh
#~/.zlogin

# Auto startx depending on the tty
if [[ -z $DISPLAY ]] && (( $EUID != 0 )) {
    [[ ${TTY/tty} != $TTY ]] && (( ${TTY:8:1} <= 3 )) &&
        startx 1>/dev/null 2>&1 &
}
