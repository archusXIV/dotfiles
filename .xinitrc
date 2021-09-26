#!/bin/sh

# this file is run when calling startx
# default arch init scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*.sh; do
        [ -x "$f" ] && source "$f"
    done
    unset f
fi

# user init scripts and settings.
MAIL="/var/spool/mail"

if [ ! -d "$MAIL" ]; then
    sudo mkdir "$MAIL" >/dev/null 2>&1
    sudo systemctl restart shadow.service
fi

# These guys are environment variables.
[ -f $MODMAP ] && xmodmap $MODMAP
[ -f $RESOURCES_FILE ] && xrdb -load $RESOURCES_FILE

# Some other early settings
systemctl --user import-environment DISPLAY
systemctl --user start pulseaudio.service
xset s off -dpms
xset r rate 300 70
setxkbmap -layout fr
urxvtd -q -o -f &
numlockx on &

# keyring and polkit daemon.
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
gnome-keyring-daemon --start --components=pkcs11 &

# more stuff
nvidia_layout &
autostart &

# launch the session, commands below these lines will be ignored
# Starting Xsession depending on tty.
# refers to $HOME/.config/zsh/.zlogin
case $(tty | cut -b9-) in
    (1) exec bspwm ;;
    (2) exec i3 ;;
    (3) qtile start ;;
esac
