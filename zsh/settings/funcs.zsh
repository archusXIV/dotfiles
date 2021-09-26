#!/usr/bin/zsh

# shell helper functions
####### better ls and cd #########
unalias ls >/dev/null 2>&1
ls() { command ls -al --color=auto -F "$@"; }

unalias cd >/dev/null 2>&1
cd() { builtin cd "$@" && command ls -al --color=auto -F; }
..() { builtin cd .. && command ls -al --color=auto -F; }
...() { builtin cd ../.. && command ls -al --color=auto -F; }
....() { builtin cd ../../.. && command ls -al --color=auto -F; }

# create directories and autocd into the leaf,
# if $1 already exist then cd into it & list content
mkcd()
{
    if (( ARGC != 1 )); then
        printf 'usage: mkcd <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '`%s'\'' already exists: cd-ing.\n' "$1"
    fi
    builtin cd "$1" && command ls -al --color=auto -F
}

# man
mano()
{
    LESS_TERMCAP_md=$'\e[01;32m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;31m' \
    command man "$@"
}

# remove a directory/file and refresh viewport
rmd() { rm -r "$@" && ls -a --color=auto -F; }

por()
{
    local orphans
    orphans="$(pacman -Qtdq 2>/dev/null)"
    [[ -z $orphans ]] && printf "System has no orphaned packages\n" || sudo pacman -Rns $orphans
}

# find all webm files that are in the current directory/sub-folders and extract the audio to mp3 format.
webm_to_mp3()
{
    find . -type f -iname "*.webm" -exec bash -c 'FILE="$1"; \
    ffmpeg -i "${FILE}" -vn -ab 320k -ar 44100 -y "${FILE%.webm}.mp3";' _ '{}' \;
}

flac_to_mp3()
{
    for i in "${1:-.}"/*.flac; do
        [[ -e "${1:-.}/$(basename "$i" | sed 's/.flac/.mp3/g')" ]] || ffmpeg -i "$i" -qscale:a 0 "${i/%flac/mp3}"
    done
}

mktar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

mkzip() { zip -r "${1%%/}.zip" "$@"; }

pcun() { sudo pacman -Rs "$@" && sudo paccache -ruk0; }

pacSs()
{
    echo -e "$(pacman -Ss "$@" | sed \
        -e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
        -e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
        -e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
        -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g')"
}

pss() {
    PS3=$'\n'"Enter a package number to install, Ctrl C to exit"$'\n\n'">> "
    select pkg in $(pacman -Ssq "$1"); do sudo pacman -S $pkg; break; done
}

rename() {
  find . -depth -name "* *" -exec \
   bash -c '
      for f in "$@"; do
          n="${f##*/}"
          mv -nv "$f" "${f%/*}/${n// /_}"
      done
   ' dummy {} +
}

renger()
{
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

resize()
{
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

arc()
{
    arg="$1"; shift
    case $arg in
        -e|--extract)
            if [[ $1 && -e $1 ]]; then
                case $1 in
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
        egrep --exclude-dir=.git -lRZ "$1" $3 | xargs -0 -l sed -i -e "s/$1/$2/g"
    fi
}

