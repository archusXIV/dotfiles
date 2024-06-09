#!/bin/zsh
# ~/.zshenv

# Setting our path
[ -d "$HOME"/bin ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME"/.local/bin ] && PATH="$HOME/.local/bin:$PATH"
[ -d /usr/sbin ] && PATH="$PATH:/usr/sbin"
[ -d /sbin ] && PATH="$PATH:/sbin"

if [ -n "$(pidof nvidia-persistenced)" ]; then
    export MONITOR1="DVI-D-0"
    export MONITOR2="HDMI-0"
    export MONITOR3="DP-0"
else
    export MONITOR1="DVI-D-1"
    export MONITOR2="HDMI-1"
    export MONITOR3="DP-1"
fi

# Desktop & directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_RUNTIME_DIR="/run/user/1000/"
export BUILDIR="$HOME/makepkg"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/nvidia"
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export SCRIPTDIR="$HOME/.local/bin"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Default programs.
export BROWSER="firefox"
export EDITOR="lite-xl"
export FILEMNGR="pcmanfm"
export MANPAGER="/bin/sh -c \"col -b | vim --not-a-term -c 'set ft=man ts=8 nomod nolist noma' -\""
export MIXER="pulsemixer"
export PAGER="less"
export READER="zathura"
export TERMINAL="alacritty"
export VIDEORECORDER="simplescreenrecorder"
export VIRTMNGR="VirtualBox"
export VISUAL="vim"

# Configs & files.
export BSPWM_SOCKET="$XDG_RUNTIME_DIR"/bspwm_0_0-socket
export DKRC="$XDG_CONFIG_HOME"/dk/dkrc
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export LANG="en_US.UTF-8"
export LESSHISTFILE="-"
export MANWIDTH=100
export MBSYNCRC="$XDG_CONFIG_HOME"/isync/mbsyncrc
export MODMAP="$XDG_CONFIG_HOME"/xfiles/Xmodmap
export NANORC_FILE="$XDG_CONFIG_HOME"/nano/nanorc
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME"/notmuch/notmuchrc
export RESOURCES_FILE="$HOME"/.Xresources
export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd-socket
export SXHKD_FIFO="$XDG_RUNTIME_DIR="/sxhkd.fifo
export VIMINIT=":source $XDG_CONFIG_HOME"/vim/vimrc
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export XCURSOR_PATH="${XCURSOR_PATH}:~/.local/share/icons"
