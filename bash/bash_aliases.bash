#!/bin/bash

if hash nvim >/dev/null 2>&1; then
    alias vim='nvim'
    alias v='nvim'
    alias suv='sudo nvim'
else
    alias vi='vim'
    alias v='vim'
    alias suv='sudo vim'
fi

## MULTIMEDIA
alias \
        nc='ncmpcpp -S clock --quiet' \
        recvid='ffmpeg -video_size 1920x1080 -framerate 60 -f x11grab -i :0.0 -c:v libx264 -qp 0 -preset ultrafast $HOME/Documents/Videos/$(date +%a-%d-%S).mkv' \
        st='Xtreamripper' \
        mm='mpm' \
        mt='mpm_test' \
        ytdlf='yt-dlp -F'

## UTILITIES & GENERAL INFO
alias \
        c='clear' \
        cnews='mpv --idle=no --ytdl-format=hls-5 https://www.dailymotion.com/video/x3b68jn' \
        grep='grep --color=auto' \
        ht='htop -u archangel -s Command' \
        nano='nano --rcfile $NANORC_FILE' \
        pst='polybar_start' \
        q='exit 0' \
        sf='sudo ranger' \
        so='source $HOME/.config/bash/.bashrc' \
        vc='vim_conf' \
        vs='vim_script' \
        w='curl -L wttr.in/Le-Perreux-sur-Marne' \
        x='chmod +x' \
        xp='xprop | grep WM_CLASS' \
        xreload='xrdb load $RESOURCES_FILE'

## RC's & CONFIGS
alias \
        aliases='v $HOME/.config/bash/bash_aliases.bash' \
        bashrc='v $HOME/.config/bash/.bashrc' \
        bprofile='v $HOME/.config/bash/bash_profile' \
        bspcrc='v $HOME/.config/sxhkd/sxhkdrc_bspwm' \
        bspwmrc='v $HOME/.config/bspwm/bspwmrc' \
        dkrc='v $HOME/.config/dk/dkrc' \
        funcs='v $HOME/.config/bash/bash_funcs.bash' \
        gpgl='gpg --homedir=$XDG_DATA_HOME/gnupg --list-keys' \
        i3config='v $HOME/.config/i3/config' \
        sxhkdrc='v $HOME/.config/sxhkd/sxhkdrc' \
        vimrc='v $HOME/.config/vim/vimrc' \
        xinitrc='v $HOME/.config/X11/xinitrc' \
        Xresources='v $HOME/.config/xfiles/Xresources'

## SYSTEM
alias \
        enabled='systemctl list-unit-files --state=enabled' \
        enabledu='systemctl --user list-unit-files --state=enabled' \
        failed='systemctl list-unit-files --state=failed' \
        kdp='g810_delete_profile' \
        ksp='g810_switch_profile' \
        kcp='g810_create_profile' \
        timers='systemctl list-timers' \
        grub='sudo grub-mkconfig -o /boot/grub/grub.cfg' \
        kernel='sudo mkinitcpio -P' \
        lsa='ls -al --color=auto --group-directories-first' \
        mpminst='cd /home/archangel/.local/bin/mpv-playlists-manager && sudo ./install.sh' \
        out='Xexit' \
        sshon='sudo systemctl stop iptables.service && sudo ufw enable && sudo systemctl start sshd' \
        sshoff='sudo ufw disable && sudo systemctl start iptables.service && sudo systemctl stop sshd' \
        sx='startx'

## PACKAGES MANAGEMNT
alias \
        lspkg='ls /var/cache/pacman/pkg | more' \
        mir='sudo reflector --verbose --country France --age 24 --latest 10 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist' \
        orphans='pacman -Qdqt' \
        orphans!='sudo pacman -Rs $(pacman -Qdqt) && sudo /usr/bin/paccache -ruk0' \
        cleancache='sudo pacman -Scc' \
        plsa='pacman -Qm' \
        get='sudo pacman -S --needed' \
        del='sudo pacman -R --nosave --recursive' \
        psyu='sudo pacman -Syu' \
        umh='updates-manager --hook' \
        uml='updates-manager --list' \
        yeah='yay -Sua'
