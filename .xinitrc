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

if [ ! -e "$MAIL" ]; then
    sudo mkdir -p "$MAIL" >/dev/null 2>&1
    sudo systemctl restart shadow.timer
fi

dbus-update-activation-environment --systemd --all
systemctl --user import-environment DISPLAY
# personal startup services
systemctl --user start Xsession.target &

# These guys are environment variables.
if [ -f "$MODMAP" ], then
    xmodmap "$MODMAP"
else
    xmodmap -pke > ~/.config/xfiles/Xmodmap
    xmodmap ~/.config/xfiles/Xmodmap
fi

[ -f "$RESOURCES_FILE" ] && xrdb -load "$RESOURCES_FILE"

# more stuff (personal scripts).
nvidia-settings -l
xset s off -dpms
xset r rate 350 70
xset -r 41
setxkbmap -option caps:swapescape
urxvtd -q -o -f &
numlockx on &
pcmanfm -d &
autostart &

# launch the session, commands below these lines will be ignored
# Starting Xsession depending on tty.
# refers to $HOME/.config/zsh/.zlogin
case $(tty | cut -b9-) in
    (1) exec bspwm  ;;
    (2) exec i3     ;;
    (3) exec dk     ;;
esac
