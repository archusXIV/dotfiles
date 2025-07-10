#!/bin/zsh

command_not_found_handler() {
  local pkgs cmd

    pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
    cmd="$1"

    if [[ -n "$pkgs" ]]; then
        printf '%s may be found in the following packages:\n' "$cmd"
        printf '  %s\n' $pkgs[@]
    else
        printf 'zsh: command not found: %s\n' "$cmd"
    fi 1>&2

    return 127
}
