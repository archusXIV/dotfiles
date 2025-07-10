#!/usr/bin/env bash

# shell helper functions
####### better ls and cd #########
unalias ls >/dev/null 2>&1
ls() { command ls -Ahl --color=auto -F "$@"; }

unalias cd >/dev/null 2>&1
cd() { builtin cd "$@" && command ls -a --color=auto -F; }
..() { builtin cd .. && command ls -a --color=auto -F; }
...() { builtin cd ../.. && command ls -a --color=auto -F; }
....() { builtin cd ../../.. && command ls -a --color=auto -F; }

bins() {
    command cd ~/.local/bin/ || exit 1
    touch ./fzf.txt
    while [[ -f ./fzf.txt ]]; do
        find . -maxdepth 3 -type f \
            | sort -d \
            | fzf \
            --no-multi \
            --reverse \
            --cycle \
            --border rounded \
            --scroll-off=5 \
            --border-label="| ${PWD##*/} |" \
            --border-label-pos='-95:top' \
            --preview='(bat --color=always {})' \
            --preview-window="60%" \
            --bind "enter:become(vim {})" \
            --bind "esc:become(rm ./fzf.txt)"
    done
    command cd "$OLDPWD" || exit 1
}

calx() {
    echo -ne '\e[8;19;40t'
    dialog --no-shadow --calendar "" 0 0 --stdout && exit 0
}

confs() {
    command cd ~/.config/ || exit 1
    touch ./fzf.txt
    while [[ -f ./fzf.txt ]]; do
        find . -maxdepth 3 -type f \
            | sort -d \
            | fzf \
            --no-multi \
            --reverse \
            --cycle \
            --border rounded \
            --scroll-off=5 \
            --border-label="| ${PWD##*/} |" \
            --border-label-pos='102:bottom' \
            --preview='(bat --color=always {})' \
            --preview-window="60%" \
            --bind "enter:become(vim {})" \
            --bind "esc:become(rm ./fzf.txt)"
    done
    command cd .. || exit 1
}

# search a string within a bunch of files in the current directory: grep_this <string>
grep_this() {
    rg --color=always --line-number --no-heading --smart-case "${*:-}" \
        | sort -d \
        | fzf \
        --ansi \
        --cycle \
        --reverse \
        --scroll-off=5 \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2} ' \
        --preview-window 'up,65%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
}

#upgrade_cursor() {
#    cd "$HOME"/Documents/Downloads || return 1
#    local crsr
#    crsr="cursor.AppImage"
#    find . -maxdepth 1 -type f -name "Cursor-*" -exec mv {} "$crsr" \; && {
#        sudo chown root:root "$crsr"
#        sudo chmod +x  "$crsr"
#        sudo mv -f "$crsr" /usr/local/bin/"$crsr"
#    }
#}

sync_mpm() {
    rsync -aprq ~/Documents/projects/mpv-playlists-manager/* \
        ~/Documents/mpv-playlists-manager/ && \
    rsync -aprq ~/.local/bin/mpv-playlists-manager/* \
        ~/Documents/projects/mpv-playlists-manager/
}

sed_bash() {
    local list file
    #cd ~/Documents/projects/mpv-playlists-manager/lib/ || exit 1
    cd ~/.local/bin/mpv-playlists-manager/lib/ || exit 1
    mapfile -t list < <(find . -maxdepth 1 -type f -name "_*")
    case "$1" in
        --bash)
            for file in "${list[@]}"; do
                sed -i 's/#!\/bin\/bash/#!\/usr\/bin\/env bash/' "$file"
            done
        ;;
        --check)
            for file in "${list[@]}"; do
                sed -i 's/# shellcheck disable=SC2148/#!\/usr\/bin\/env bash/' "$file"
            done
        ;;
    esac
}

# create directories and autocd into the leaf,
# if $1 already exist then cd into it & list content
mkcd() {
    if (($# == 0)); then
        printf 'usage: mkcd <new-directory>\n'
        return 1
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '%s\n' "already exists: cd-ing $1"
    fi
    builtin cd "$1" && command ls -ahl --color=auto -F
}

# man
mano() {
    LESS_TERMCAP_md=$'\e[01;32m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;31m' \
    command man "$@"
}

# shellcheck disable=SC2015
# pacman stuff...
por() {
    local orphans
    orphans="$(pacman -Qtdq 2>/dev/null)"
    [[ -z $orphans ]] && printf "System has no orphaned packages\n" \
    || sudo pacman -Rns "$orphans"
}

pacs() {
    if (($# == 0)); then
        echo "usage: pacs <query>"
        return 1
    else
        sudo pacman --color=always -Ss "$@" | less -RSXFi
    fi
}

pacSs() {
    echo -e "$(pacman -Ss "$@" | sed \
        -e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
        -e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
        -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g')"
}

pacinfo() {
    pacman -Qq \
        | fzf \
        --cycle \
        --border rounded \
        --border-label='| Installed Packages |' \
        --border-label-pos='-89:top' \
        --preview 'pacman -Qil {}' \
        --preview-window='right:60%' \
        --layout=reverse \
        --scroll-off=5 \
        --bind 'enter:execute(pacman -Qil {} | less)'
}

pcun() { sudo pacman -Rs "$@" && sudo paccache -ruk0; }

pss() {
    PS3=$'\n'"Enter a package number to install, Ctrl C to exit"$'\n\n'">> "
    select pkg in $(pacman -Ssq "$1"); do sudo pacman -S "$pkg"; break; done
}

# find all webm files that are in the current directory/sub-folders and extract the audio to mp3 format.
webm_to_mp3() {
    find . -type f -iname "*.webm" -exec bash -c 'FILE="$1"; \
    ffmpeg -i "${FILE}" -vn -ab 320k -ar 44100 -y "${FILE%.webm}.mp3";' _ '{}' \;
}

flac_to_mp3() {
    for i in "${1:-.}"/*.flac; do
        [[ -e "${1:-.}/$(basename "$i" | sed 's/.flac/.mp3/g')" ]] \
        || ffmpeg -i "$i" -qscale:a 0 "${i/%flac/mp3}"
    done
}

ffmpeg_volume() { ffmpeg -i "$1" -vcodec copy -filter:a "volume=$2dB" "$3"; }

mktar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

mkzip() { zip -r "${1%%/}.zip" "$@"; }

gitupdate() {
    git fetch
    git reset --hard HEAD
    git merge '@{u}'
}

# shellcheck disable=SC1083
genpass() { shuf -er -n"$1"  {A..Z} {a..z} {0..9} {@,%,\!,$} | paste -sd ""; }

trpass() { tr -dc 'a-zA-Z0-9_#@.-' < /dev/urandom | head -c "${1:-24}"; echo; }

rename_all() {
    find . -depth -name "* *" -exec \
    bash -c '
        for f in "$@"; do
            n="${f##*/}"
            mv -nv "$f" "${f%/*}/${n// /_}"
        done
    ' {} \;
}

renger() {
    local dir tmpf
    [[ $RANGER_LEVEL && $RANGER_LEVEL -gt 2 ]] && exit 0
    local rcmd="command ranger"
    [[ $TERM == 'linux' ]] && rcmd="command ranger --cmd='set colorscheme default'"
    tmpf="$(mktemp -t tmp.XXXXXX)"
    eval "$rcmd --choosedir='$tmpf' '${*:-$(pwd)}'"
    [[ -f $tmpf ]] && dir="$(cat "$tmpf")"
    [[ -e $tmpf ]] && rm -f "$tmpf"
    [[ -z $dir || $dir == "$PWD" ]] || builtin cd "${dir}" || return 0
}

resize() {
    hash convert >/dev/null 2>&1 || { printf "This function requires imagemagick\n"; return 1; }
    local size="$1"; shift
    if [[ $size =~ [1-9]*x[1-9] && $# -ge 1 ]]; then
        if [[ $# -gt 1 || -d "$1" ]]; then
            if [[ -d "$1" ]]; then
                for i in "$1"/*; do
                    [[ $i =~ (.jpg|.png) ]] && convert "$i" -resize "$1" "$i"
                done
            else
                for i in "$@"; do
                    [[ -f $i && $i =~ (.jpg|.png) ]] && convert "$i" -resize "$1" "$i"
                done
            fi
        else
            [[ -f $1 && $1 =~ (.jpg|.png) ]] && convert "$1" -resize "$1" "$1"
        fi
    else
        printf "Usage: resize [size] [directory or file(s)]\n\n%s\n" \
            "When given a directory, all images within will be converted"
    fi
}

arc() {
    arg="$1"; shift
    case ${arg} in
        -e|--extract)
            if [[ $1 && -e $1 ]]; then
                case "$1" in
                    *.tbz2|*.tar.bz2) tar xvjf "$1" ;;
                    *.tgz|*.tar.gz) tar xvzf "$1" ;;
                    *.tar.xz) tar xpvf "$1" ;;
                    *.tar) tar xvf "$1" ;;
                    *.gz) gunzip "$1" ;;
                    *.zip) unzip "$1" ;;
                    *.bz2) bunzip2 "$1" ;;
                    *.7zip) 7za e "$1" ;;
                    *.rar) unrar x "$1" ;;
                    *) printf "'%s' cannot be extracted" "$1"
                esac
            else
                printf "'%s' is not a valid file" "$1"
            fi ;;
        -n|--new)
            case $1 in
                *.tar.*)
                    name="${1%.*}"
                    ext="${1#*.tar}"; shift
                    tar cvf "$name" "$@"
                    case $ext in
                        .gz) gzip -9r "$name" ;;
                        .bz2) bzip2 -9zv "$name"
                    esac ;;
                *.gz) shift; gzip -9rk "$@" ;;
                *.zip) zip -9r "$@" ;;
                *.7z) 7z a -mx9 "$@" ;;
                *) printf "bad/unsupported extension"
            esac ;;
        *) printf "invalid argument '%s'" "$arg"
    esac
}

# Search & replace in multiple files.
# gsed "badly_named_ruby_method" "awesome_method_name"
gsed () {
    if [ -z "$3" ]; then
        echo "== Usage:    gsed search_string replace_string [path]"
    else
        grep -E --exclude-dir=.git -lRZ "$1" "$3" | xargs -0 -l {} sed -i -e "s/$1/$2/g"
    fi
}
