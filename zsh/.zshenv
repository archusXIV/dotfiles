#!/bin/zsh
# ~/.zshenv

# Setting our path
[ -d "$HOME"/.local/bin ] && PATH="$HOME/.local/bin:$PATH"
[ -d /usr/sbin ] && PATH="$PATH:/usr/sbin"
[ -d /sbin ] && PATH="$PATH:/sbin"

export MONITOR1="DisplayPort-0"
export MONITOR2="DisplayPort-1"
export MONITOR3="DisplayPort-2"

# Desktop & directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_RUNTIME_DIR="/run/user/1000"
export XDG_STATE_HOME="$HOME/.local/state"
export BUILDIR="${XDG_CACHE_HOME:-$HOME/.cache}/makepkg"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/nvidia"
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export MPM_DIR="$XDG_DATA_HOME/mpm"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export SCRIPTDIR="$HOME/.local/bin"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export DOX="$HOME/Documents"
export MUZ="$DOX/Music"
export VID="$DOX/Videos"
export PIX="$DOX/Pictures"
export DWN="$DOX/Downloads"
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode

# Default programs.
export BROWSER="brave"
export EDITOR="lite-xl"
export FILEMNGR="thunar"
export MANPAGER="less -R --use-color -Dd+r -Du+b"
#export MANPAGER="/bin/sh -c \"col -b | vim --not-a-term -c 'set ft=man ts=8 nomod nolist noma' -\""
export MIXER="pulsemixer"
export PAGER="less"
export READER="zathura"
export TERMINAL="urxvtc"
export VIDEORECORDER="simplescreenrecorder"
export VIRTMNGR="VirtualBox"
export VISUAL="vim"

# Configs & files.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"/keyring/ssh
#export DKSOCK="/tmp/$(command ls /tmp | awk '/dk__/{print $0}')"
export BSPWM_SOCKET="$XDG_RUNTIME_DIR"/bspwm_0_0-socket
export DKRC="$XDG_CONFIG_HOME"/dk/dkrc
#export DKRC="$XDG_CONFIG_HOME"/dk/dkrc.py
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export LANG="en_US.UTF-8"
export LESSHISTFILE="-"
export MANWIDTH=100
export MBSYNCRC="$XDG_CONFIG_HOME"/isync/mbsyncrc
export MODMAP="$XDG_CONFIG_HOME"/X11/Xmodmap
export MPMRC="$XDG_CONFIG_HOME"/mpm/mpmrc
export MPVSOCKET="/tmp/mpvsocket"
export MYVIMRC="$XDG_CONFIG_HOME"/vim/vimrc
export NANORC_FILE="$XDG_CONFIG_HOME"/nano/nanorc
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME"/notmuch/notmuchrc
export QT_QPA_PLATFORMTHEME="qt6ct"
export RESOURCES_FILE="$HOME"/.Xresources
export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd-socket
export SXHKD_FIFO="$XDG_RUNTIME_DIR"/sxhkd.fifo
export VIMINIT=":source $MYVIMRC"
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export XCURSOR_PATH="${XCURSOR_PATH}:~/.local/share/icons"
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export W3M_DIR="$XDG_CONFIG_HOME/w3m"
