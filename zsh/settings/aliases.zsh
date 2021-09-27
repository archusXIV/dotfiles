#!/usr/bin/zsh

if hash nvim >/dev/null 2>&1; then
    alias vim='nvim'
    alias v='nvim'
    alias suv='sudo nvim'
else
    alias v='vim'
    alias suv='sudo vim'
fi
## MULTIMEDIA
alias \
        rr='rofi-record' \
        rrk='rofi-record -k' \
        gif='byzanz-record -x 1090 -w 750 -y 430 -h 480 -v -d 15 ~/Videos/$(date +%a-%d-%S).gif' \
        nc='ncmpcpp -S clock --quiet' \
        mpm='mpv-menu' \
        recvid='cd ~/Videos && ffmpeg -video_size 1920x1080 -framerate 60 -f x11grab -i :0.0 -c:v libx264 -qp 0 -preset ultrafast ~/Videos/$(date +%a-%d-%S).mkv' \
        recaudio='cd $HOME/Music/ && ffmpeg -f pulse -i 1 -map '0' $HOME/Music/mic_recording.mp3' \
        st='xtreamripper'

## UTILITIES & GENERAL INFO
alias \
        c='clear' \
        ccat='highlight --out-format=ansi' \
        grep='grep --color=auto' \
        ht='htop -u archangel -s Command' \
        ka='killall $@' \
        myip='wget -q -O /dev/stdout http://checkip.dyndns.org/ | cut -d : -f 2- | cut -d \< -f -1' \
        nano='nano --rcfile $NANORC_FILE' \
        q='exit 0' \
        sf='sudo ranger' \
        so='source $HOME/.config/zsh/.zshrc' \
        uvh='updates-viewer --hook' \
        uvl='updates-viewer --list' \
        vc='vim_conf' \
        vs='vim_script' \
        w='curl -L wttr.in/xxxxxxxxxxxxxxx' \
        w2='curl v2d.wttr.in/xxxxxxxxxxxxxxx?format=v2 --output "$XDG_RUNTIME_DIR"/weather && cat "$XDG_RUNTIME_DIR"/weather | grep Weather:' \
        x='chmod +x' \
        xp='xprop | grep WM_CLASS'

## RC's & CONFIGS
alias \
        aliases='v $HOME/.config/zsh/settings/aliases.zsh' \
        bspcrc='v $HOME/.config/sxhkd/sxhkdrc_bspc' \
        bspwmrc='v $HOME/.config/bspwm/bspwmrc' \
        funcs='v $HOME/.config/zsh/settings/funcs.zsh' \
        gpgl='gpg --homedir=$XDG_DATA_HOME/gnupg --list-keys' \
        i3config='v $HOME/.config/i3/config' \
        sxhkdrc='v $HOME/.config/sxhkd/sxhkdrc' \
        vimrc='v $HOME/.config/vim/vimrc' \
        xinitrc='v $HOME/.xinitrc' \
        Xresources='v $HOME/.Xresources' \
        zlogin='v $HOME/.config/zsh/.zlogin' \
        zshenv='v $HOME/.zshenv' \
        zshrc='v $HOME/.config/zsh/.zshrc'

## SYSTEM
alias \
        enabled='systemctl list-unit-files --state=enabled' \
        enabledu='systemctl --user list-unit-files --state=enabled' \
        failed='systemctl list-unit-files --state=failed' \
        timers='systemctl list-timers' \
        grub='sudo grub-mkconfig -o /boot/grub/grub.cfg' \
        kernel='sudo mkinitcpio -p linux' \
        lsa='ls -al --color=auto --group-directories-first' \
        out='session-logout || pkill -15 -t tty"$XDG_VTNR" Xorg' \
        sshon='sudo systemctl stop iptables.service && sudo ufw enable && sudo systemctl start sshd' \
        sshoff='sudo ufw disable && sudo systemctl start iptables.service && sudo systemctl stop sshd' \
        swap='sudo swapoff -a && sudo swapon -a' \
        sx='startx'

## PACKAGES MANAGEMNT
alias \
        lspkg='ls /var/cache/pacman/pkg | more' \
        mir='sudo reflector --verbose --country 'France' --latest 15 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist' \
        mk='make-packages' \
        orphans='pacman -Qdqt' \
        orphans!='sudo pacman -Rs $(pacman -Qdqt) && sudo /usr/bin/paccache -ruk0' \
        cleancache='sudo pacman -Scc' \
        install='sudo pacman -Syy $1' \
        plsa='pacman -Qm' \
        remove='sudo pacman -R --nosave --recursive' \
        psyu='sudo pacman -Syu && polybar-msg hook updates-ipc 2 >/dev/null &' \
        supp='sudo upp' \
        trz='trizen -S' \
        trzs='trizen -Ss --aur' \
        trzu='trizen_update'
