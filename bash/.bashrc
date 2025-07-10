#!/bin/bash

# shellcheck disable=SC2034
# shellcheck source=/dev/null
# catch non-bash and non-interactive shells
[[ $- == *i* && $BASH_VERSION ]] && SHELL=/bin/bash || return 0

HISTFILE="$HOME/.config/bash/bash_history"

# ensure ~/.local/bin is in our path
[[ -d $HOME/.local/bin ]] && PATH="$HOME/.local/bin:$PATH"
SCRIPTDIR="$HOME/.local/bin"
path+=("$SCRIPTDIR" "${SCRIPTDIR}"/*/)
export PATH

# source shell aliases & functions
for f in "$XDG_CONFIG_HOME"/bash/*.bash; do
    . "$f"
done
. ~/.config/mpm/mpmrc
. ~/.config/mpm/themerc

set -o vi
set -o notify

shopt -s direxpand
shopt -s checkhash
shopt -s sourcepath
shopt -s expand_aliases
shopt -s autocd cdspell
shopt -s extglob dotglob
shopt -s no_empty_cmd_completion
shopt -s autocd cdable_vars cdspell
shopt -s cmdhist histappend histreedit histverify
export HISTCONTOL="ignoreboth:erasdups"

[[ -n $DISPLAY ]] && shopt -s checkwinsize

eval "$(fzf --bash)"

# Colours have names too. Stolen from Arch wiki
txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
bakblk='\[\e[40m\]'   # Black - Background
bakred='\[\e[41m\]'   # Red
badgrn='\[\e[42m\]'   # Green
bakylw='\[\e[43m\]'   # Yellow
bakblu='\[\e[44m\]'   # Blue
bakpur='\[\e[45m\]'   # Purple
bakcyn='\[\e[46m\]'   # Cyan
bakwht='\[\e[47m\]'   # White
txtrst='\[\e[0m\]'    # Text Reset

# Prompt colours
atC="${txtcyn}"
dateC="${txtylw}"
nameC="${bldblu}"
hostC="${txtgrn}"
pathC="${txtgrn}"
gitC="${txtpur}"
pointerC="${txtred}"
normalC="${txtcyn}"

# Red name for root
if [[ ${UID} -eq "0" ]]; then
  nameC="${txtred}"
fi

PS1="\n ${dateC} \t ${nameC}\u${atC}@${hostC}\h: ${pathC}\${PWD##*/}
  ============================
${pointerC} ▶ ${txtrst}"
