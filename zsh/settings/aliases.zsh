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
        nc='ncmpcpp -S clock --quiet' \
        recvid='cd ~/Documents/Videos && ffmpeg -video_size 1920x1080 -framerate 60 -f x11grab -i :0.0 -c:v libx264 -qp 0 -preset ultrafast $HOME/Documents/Videos/$(date +%a-%d-%S).mkv' \
        recaudio='cd ~/Documents/Music/ && ffmpeg -f pulse -i 1 -map '0' $HOME/Documents/Music/mic_recording.mp3' \
        st='Xtreamripper' \
        mm='mpm' \
        mt='mpm_test' \
        ytdlf='youtube-dl -F'

## UTILITIES & GENERAL INFO
alias \
        c='clear' \
        grep='grep --color=auto' \
        ht='htop -u archangel -s Command' \
        nano='nano --rcfile $NANORC_FILE' \
        q='exit 0' \
        sf='sudo ranger' \
        so='source $HOME/.config/zsh/.zshrc' \
        vc='vim_conf' \
        vs='vim_script' \
        w='curl -L wttr.in/Le-Perreux-sur-Marne' \
        w2='curl v2d.wttr.in/Le-Perreux-sur-Marne?format=v2 --output "$XDG_RUNTIME_DIR"/weather && cat "$XDG_RUNTIME_DIR"/weather | grep Weather:' \
        x='chmod +x' \
        xp='xprop | grep WM_CLASS' \
        xreload='xrdb load $RESOURCES_FILE'

## RC's & CONFIGS
alias \
        aliases='v $HOME/.config/zsh/settings/aliases.zsh' \
        bspcrc='v $HOME/.config/sxhkd/sxhkdrc_bspc' \
        bspwmrc='v $HOME/.config/bspwm/bspwmrc' \
        dkrc='v $HOME/.config/dk/dkrc' \
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
        fsctl='sudo fzf_systemctl' \
        ksp='g810_switch_profile' \
        timers='systemctl list-timers --all' \
        grub='sudo grub-mkconfig -o /boot/grub/grub.cfg' \
        kernel='sudo mkinitcpio -P' \
        lsa='ls -al --color=auto --group-directories-first' \
        out='session-logout || pkill -15 -t tty"$XDG_VTNR" Xorg' \
        sshon='sudo systemctl stop iptables.service && sudo ufw enable && sudo systemctl start sshd' \
        sshoff='sudo ufw disable && sudo systemctl start iptables.service && sudo systemctl stop sshd' \
        sx='startx'

## PACKAGES MANAGEMNT
alias \
        lspkg='ls /var/cache/pacman/pkg | more' \
        mir='sudo reflector --verbose --country 'France' --age 24 --latest 15 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist' \
        mpminst='sudo ./install.sh' \
        orphans='pacman -Qdqt' \
        orphans!='sudo pacman -Rs $(pacman -Qdqt) && sudo /usr/bin/paccache -ruk0' \
        cleancache='sudo pacman -Scc' \
        pacinstall='sudo pacman -Sy $1' \
        pacinfo='pacman -Qi $1' \
        plsa='pacman -Qm' \
        remove='sudo pacman -R --nosave --recursive' \
        psyu='sudo pacman -Syu' \
        umh='updates-manager --hook' \
        uml='updates-manager --list' \
        yeah='yay -Sua'
