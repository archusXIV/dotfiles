#!/bin/bash

#   bash_completion - programmable completion functions for bash 4.1+
#
#   Copyright © 2006-2008, Ian Macdonald <ian@caliban.org>
#             © 2009-2018, Bash Completion Maintainers
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or (at your option)
#   any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#   The latest version of this software can be obtained here:
#
#   https://github.com/scop/bash-completion

export BASH_COMPLETION_VERSINFO=(2 8)

if [[ $- == *v* ]]; then
    BASH_COMPLETION_ORIGINAL_V_VALUE="-v"
else
    BASH_COMPLETION_ORIGINAL_V_VALUE="+v"
fi

if [[ ${BASH_COMPLETION_DEBUG-} ]]; then
    set -v
else
    set +v
fi

# Blacklisted completions, causing problems with our code.
#
_blacklist_glob='@(acroread.sh)'

# Turn on extended globbing and programmable completion
shopt -s extglob progcomp

# A lot of the following one-liners were taken directly from the
# completion examples provided with the bash 2.04 source distribution

# start of section containing compspecs that can be handled within bash

# user commands see only users
complete -u groups slay w sux

# bg completes with stopped jobs
complete -A stopped -P '"%' -S '"' bg

# other job commands
complete -j -P '"%' -S '"' fg jobs disown

# readonly and unset complete with shell variables
complete -v readonly unset

# set completes with set options
complete -A setopt set

# shopt completes with shopt options
complete -A shopt shopt

# helptopics
complete -A helptopic help

# unalias completes with aliases
complete -a unalias

# type and which complete on commands
complete -c command type which

# builtin completes on builtins
complete -b builtin

# start of section containing completion functions called by other functions

# Check if we're running on the given userland
# @param $1 userland to check for
_userland()
{
    local userland
    userland=$( uname -s )
    [[ $userland == @(Linux|GNU/*) ]] && userland=GNU
    [[ $userland == "$1" ]]
}

# This function sets correct SysV init directories
#
_sysvdirs()
{
    sysvdirs=( )
    [[ -d /etc/rc.d/init.d ]] && sysvdirs+=( /etc/rc.d/init.d )
    [[ -d /etc/init.d ]] && sysvdirs+=( /etc/init.d )
    # Slackware uses /etc/rc.d
    [[ -f /etc/slackware-version ]] && sysvdirs=( /etc/rc.d )
}

# This function checks whether we have a given program on the system.
#
_have()
{
    # Completions for system administrator commands are installed as well in
    # case completion is attempted via `sudo command ...'.
    PATH=$PATH:/usr/sbin:/sbin:/usr/local/sbin type $1 &>/dev/null
}

# Backwards compatibility for compat completions that use have().
# @deprecated should no longer be used; generally not needed with dynamically
#             loaded completions, and _have is suitable for runtime use.
have()
{
    unset -v have
    _have $1 && have=yes
}

# This function checks whether a given readline variable
# is `on'.
#
_rl_enabled()
{
    [[ "$( bind -v )" == *$1+([[:space:]])on* ]]
}

# This function shell-quotes the argument
quote()
{
    local quoted=${1//\'/\'\\\'\'}
    printf "'%s'" "$quoted"
}

# @see _quote_readline_by_ref()
quote_readline()
{
    local quoted
    _quote_readline_by_ref "$1" ret
    printf %s "$ret"
} # quote_readline()


# This function shell-dequotes the argument
dequote()
{
    eval printf %s "$1" 2> /dev/null
}


# Assign variable one scope above the caller
# Usage: local "$1" && _upvar $1 "value(s)"
# Param: $1  Variable name to assign value to
# Param: $*  Value(s) to assign.  If multiple values, an array is
#            assigned, otherwise a single value is assigned.
# NOTE: For assigning multiple variables, use '_upvars'.  Do NOT
#       use multiple '_upvar' calls, since one '_upvar' call might
#       reassign a variable to be used by another '_upvar' call.
# See: http://fvue.nl/wiki/Bash:_Passing_variables_by_reference
_upvar()
{
    if unset -v "$1"; then           # Unset & validate varname
        if (( $# == 2 )); then
            eval $1=\"\$2\"          # Return single value
        else
            eval $1=\(\"\${@:2}\"\)  # Return array
        fi
    fi
}


# Assign variables one scope above the caller
# Usage: local varname [varname ...] &&
#        _upvars [-v varname value] | [-aN varname [value ...]] ...
# Available OPTIONS:
#     -aN  Assign next N values to varname as array
#     -v   Assign single value to varname
# Return: 1 if error occurs
# See: http://fvue.nl/wiki/Bash:_Passing_variables_by_reference
_upvars()
{
    if ! (( $# )); then
        echo "${FUNCNAME[0]}: usage: ${FUNCNAME[0]} [-v varname"\
            "value] | [-aN varname [value ...]] ..." 1>&2
        return 2
    fi
    while (( $# )); do
        case $1 in
            -a*)
                # Error checking
                [[ ${1#-a} ]] || { echo "bash: ${FUNCNAME[0]}: \`$1': missing"\
                    "number specifier" 1>&2; return 1; }
                printf %d "${1#-a}" &> /dev/null || { echo "bash:"\
                    "${FUNCNAME[0]}: \`$1': invalid number specifier" 1>&2
                    return 1; }
                # Assign array of -aN elements
                [[ "$2" ]] && unset -v "$2" && eval $2=\(\"\${@:3:${1#-a}}\"\) &&
                shift $((${1#-a} + 2)) || { echo "bash: ${FUNCNAME[0]}:"\
                    "\`$1${2+ }$2': missing argument(s)" 1>&2; return 1; }
                ;;
            -v)
                # Assign single value
                [[ "$2" ]] && unset -v "$2" && eval $2=\"\$3\" &&
                shift 3 || { echo "bash: ${FUNCNAME[0]}: $1: missing"\
                "argument(s)" 1>&2; return 1; }
                ;;
            *)
                echo "bash: ${FUNCNAME[0]}: $1: invalid option" 1>&2
                return 1 ;;
        esac
    done
}


# Reassemble command line words, excluding specified characters from the
# list of word completion separators (COMP_WORDBREAKS).
# @param $1 chars  Characters out of $COMP_WORDBREAKS which should
#     NOT be considered word breaks. This is useful for things like scp where
#     we want to return host:path and not only path, so we would pass the
#     colon (:) as $1 here.
# @param $2 words  Name of variable to return words to
# @param $3 cword  Name of variable to return cword to
#
__reassemble_comp_words_by_ref()
{
    local exclude i j line ref
    # Exclude word separator characters?
    if [[ $1 ]]; then
        # Yes, exclude word separator characters;
        # Exclude only those characters, which were really included
        exclude="${1//[^$COMP_WORDBREAKS]}"
    fi

    # Default to cword unchanged
    printf -v "$3" %s "$COMP_CWORD"
    # Are characters excluded which were former included?
    if [[ $exclude ]]; then
        # Yes, list of word completion separators has shrunk;
        line=$COMP_LINE
        # Re-assemble words to complete
        for (( i=0, j=0; i < ${#COMP_WORDS[@]}; i++, j++)); do
            # Is current word not word 0 (the command itself) and is word not
            # empty and is word made up of just word separator characters to
            # be excluded and is current word not preceded by whitespace in
            # original line?
            while [[ $i -gt 0 && ${COMP_WORDS[$i]} == +([$exclude]) ]]; do
                # Is word separator not preceded by whitespace in original line
                # and are we not going to append to word 0 (the command
                # itself), then append to current word.
                [[ $line != [[:blank:]]* ]] && (( j >= 2 )) && ((j--))
                # Append word separator to current or new word
                ref="$2[$j]"
                printf -v "$ref" %s "${!ref}${COMP_WORDS[i]}"
                # Indicate new cword
                [[ $i == $COMP_CWORD ]] && printf -v "$3" %s "$j"
                # Remove optional whitespace + word separator from line copy
                line=${line#*"${COMP_WORDS[$i]}"}
                # Start new word if word separator in original line is
                # followed by whitespace.
                [[ $line == [[:blank:]]* ]] && ((j++))
                # Indicate next word if available, else end *both* while and
                # for loop
                (( $i < ${#COMP_WORDS[@]} - 1)) && ((i++)) || break 2
            done
            # Append word to current word
            ref="$2[$j]"
            printf -v "$ref" %s "${!ref}${COMP_WORDS[i]}"
            # Remove optional whitespace + word from line copy
            line=${line#*"${COMP_WORDS[i]}"}
            # Indicate new cword
            [[ $i == $COMP_CWORD ]] && printf -v "$3" %s "$j"
        done
        [[ $i == $COMP_CWORD ]] && printf -v "$3" %s "$j"
    else
        # No, list of word completions separators hasn't changed;
        for i in "${!COMP_WORDS[@]}"; do
            printf -v "$2[i]" %s "${COMP_WORDS[i]}"
        done
    fi
} # __reassemble_comp_words_by_ref()


# @param $1 exclude  Characters out of $COMP_WORDBREAKS which should NOT be
#     considered word breaks. This is useful for things like scp where
#     we want to return host:path and not only path, so we would pass the
#     colon (:) as $1 in this case.
# @param $2 words  Name of variable to return words to
# @param $3 cword  Name of variable to return cword to
# @param $4 cur  Name of variable to return current word to complete to
# @see __reassemble_comp_words_by_ref()
__get_cword_at_cursor_by_ref()
{
    local cword words=()
    __reassemble_comp_words_by_ref "$1" words cword

    local i cur index=$COMP_POINT lead=${COMP_LINE:0:$COMP_POINT}
    # Cursor not at position 0 and not leaded by just space(s)?
    if [[ $index -gt 0 && ( $lead && ${lead//[[:space:]]} ) ]]; then
        cur=$COMP_LINE
        for (( i = 0; i <= cword; ++i )); do
            while [[
                # Current word fits in $cur?
                ${#cur} -ge ${#words[i]} &&
                # $cur doesn't match cword?
                "${cur:0:${#words[i]}}" != "${words[i]}"
            ]]; do
                # Strip first character
                cur="${cur:1}"
                # Decrease cursor position, staying >= 0
                [[ $index -gt 0 ]] && ((index--))
            done

            # Does found word match cword?
            if [[ $i -lt $cword ]]; then
                # No, cword lies further;
                local old_size=${#cur}
                cur="${cur#"${words[i]}"}"
                local new_size=${#cur}
                index=$(( index - old_size + new_size ))
            fi
        done
        # Clear $cur if just space(s)
        [[ $cur && ! ${cur//[[:space:]]} ]] && cur=
        # Zero $index if negative
        [[ $index -lt 0 ]] && index=0
    fi

    local "$2" "$3" "$4" && _upvars -a${#words[@]} $2 "${words[@]}" \
        -v $3 "$cword" -v $4 "${cur:0:$index}"
}


# Get the word to complete and optional previous words.
# This is nicer than ${COMP_WORDS[$COMP_CWORD]}, since it handles cases
# where the user is completing in the middle of a word.
# (For example, if the line is "ls foobar",
# and the cursor is here -------->   ^
# Also one is able to cross over possible wordbreak characters.
# Usage: _get_comp_words_by_ref [OPTIONS] [VARNAMES]
# Available VARNAMES:
#     cur         Return cur via $cur
#     prev        Return prev via $prev
#     words       Return words via $words
#     cword       Return cword via $cword
#
# Available OPTIONS:
#     -n EXCLUDE  Characters out of $COMP_WORDBREAKS which should NOT be
#                 considered word breaks. This is useful for things like scp
#                 where we want to return host:path and not only path, so we
#                 would pass the colon (:) as -n option in this case.
#     -c VARNAME  Return cur via $VARNAME
#     -p VARNAME  Return prev via $VARNAME
#     -w VARNAME  Return words via $VARNAME
#     -i VARNAME  Return cword via $VARNAME
#
# Example usage:
#
#    $ _get_comp_words_by_ref -n : cur prev
#
_get_comp_words_by_ref()
{
    local exclude flag i OPTIND=1
    local cur cword words=()
    local upargs=() upvars=() vcur vcword vprev vwords

    while getopts "c:i:n:p:w:" flag "$@"; do
        case $flag in
            c) vcur=$OPTARG ;;
            i) vcword=$OPTARG ;;
            n) exclude=$OPTARG ;;
            p) vprev=$OPTARG ;;
            w) vwords=$OPTARG ;;
        esac
    done
    while [[ $# -ge $OPTIND ]]; do
        case ${!OPTIND} in
            cur)   vcur=cur ;;
            prev)  vprev=prev ;;
            cword) vcword=cword ;;
            words) vwords=words ;;
            *) echo "bash: $FUNCNAME(): \`${!OPTIND}': unknown argument" \
                1>&2; return 1
        esac
        let "OPTIND += 1"
    done

    __get_cword_at_cursor_by_ref "$exclude" words cword cur

    [[ $vcur   ]] && { upvars+=("$vcur"  ); upargs+=(-v $vcur   "$cur"  ); }
    [[ $vcword ]] && { upvars+=("$vcword"); upargs+=(-v $vcword "$cword"); }
    [[ $vprev && $cword -ge 1 ]] && { upvars+=("$vprev" ); upargs+=(-v $vprev
        "${words[cword - 1]}"); }
    [[ $vwords ]] && { upvars+=("$vwords"); upargs+=(-a${#words[@]} $vwords
        "${words[@]}"); }

    (( ${#upvars[@]} )) && local "${upvars[@]}" && _upvars "${upargs[@]}"
}


# Get the word to complete.
# This is nicer than ${COMP_WORDS[$COMP_CWORD]}, since it handles cases
# where the user is completing in the middle of a word.
# (For example, if the line is "ls foobar",
# and the cursor is here -------->   ^
# @param $1 string  Characters out of $COMP_WORDBREAKS which should NOT be
#     considered word breaks. This is useful for things like scp where
#     we want to return host:path and not only path, so we would pass the
#     colon (:) as $1 in this case.
# @param $2 integer  Index number of word to return, negatively offset to the
#     current word (default is 0, previous is 1), respecting the exclusions
#     given at $1.  For example, `_get_cword "=:" 1' returns the word left of
#     the current word, respecting the exclusions "=:".
# @deprecated  Use `_get_comp_words_by_ref cur' instead
# @see _get_comp_words_by_ref()
_get_cword()
{
    local LC_CTYPE=C
    local cword words
    __reassemble_comp_words_by_ref "$1" words cword

    # return previous word offset by $2
    if [[ ${2//[^0-9]/} ]]; then
        printf "%s" "${words[cword-$2]}"
    elif [[ "${#words[cword]}" -eq 0 || "$COMP_POINT" == "${#COMP_LINE}" ]]; then
        printf "%s" "${words[cword]}"
    else
        local i
        local cur="$COMP_LINE"
        local index="$COMP_POINT"
        for (( i = 0; i <= cword; ++i )); do
            while [[
                # Current word fits in $cur?
                "${#cur}" -ge ${#words[i]} &&
                # $cur doesn't match cword?
                "${cur:0:${#words[i]}}" != "${words[i]}"
            ]]; do
                # Strip first character
                cur="${cur:1}"
                # Decrease cursor position, staying >= 0
                [[ $index -gt 0 ]] && ((index--))
            done

            # Does found word matches cword?
            if [[ "$i" -lt "$cword" ]]; then
                # No, cword lies further;
                local old_size="${#cur}"
                cur="${cur#${words[i]}}"
                local new_size="${#cur}"
                index=$(( index - old_size + new_size ))
            fi
        done

        if [[ "${words[cword]:0:${#cur}}" != "$cur" ]]; then
            # We messed up! At least return the whole word so things
            # keep working
            printf "%s" "${words[cword]}"
        else
            printf "%s" "${cur:0:$index}"
        fi
    fi
} # _get_cword()


# Get word previous to the current word.
# This is a good alternative to `prev=${COMP_WORDS[COMP_CWORD-1]}' because bash4
# will properly return the previous word with respect to any given exclusions to
# COMP_WORDBREAKS.
# @deprecated  Use `_get_comp_words_by_ref cur prev' instead
# @see _get_comp_words_by_ref()
#
_get_pword()
{
    if [[ $COMP_CWORD -ge 1 ]]; then
        _get_cword "${@:-}" 1
    fi
}


# If the word-to-complete contains a colon (:), left-trim COMPREPLY items with
# word-to-complete.
# With a colon in COMP_WORDBREAKS, words containing
# colons are always completed as entire words if the word to complete contains
# a colon.  This function fixes this, by removing the colon-containing-prefix
# from COMPREPLY items.
# The preferred solution is to remove the colon (:) from COMP_WORDBREAKS in
# your .bashrc:
#
#    # Remove colon (:) from list of word completion separators
#    COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
#
# See also: Bash FAQ - E13) Why does filename completion misbehave if a colon
# appears in the filename? - http://tiswww.case.edu/php/chet/bash/FAQ
# @param $1 current word to complete (cur)
# @modifies global array $COMPREPLY
#
__ltrim_colon_completions()
{
    if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
        # Remove colon-word prefix from COMPREPLY items
        local colon_word=${1%"${1##*:}"}
        local i=${#COMPREPLY[*]}
        while [[ $((--i)) -ge 0 ]]; do
            COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
        done
    fi
} # __ltrim_colon_completions()


# This function quotes the argument in a way so that readline dequoting
# results in the original argument.  This is necessary for at least
# `compgen' which requires its arguments quoted/escaped:
#
#     $ ls "a'b/"
#     c
#     $ compgen -f "a'b/"       # Wrong, doesn't return output
#     $ compgen -f "a\'b/"      # Good
#     a\'b/c
#
# See also:
# - http://lists.gnu.org/archive/html/bug-bash/2009-03/msg00155.html
# - http://www.mail-archive.com/bash-completion-devel@lists.alioth.\
#   debian.org/msg01944.html
# @param $1  Argument to quote
# @param $2  Name of variable to return result to
_quote_readline_by_ref()
{
    if [[ $1 == \'* ]]; then
        # Leave out first character
        printf -v $2 %s "${1:1}"
    else
        printf -v $2 %q "$1"
    fi

    # If result becomes quoted like this: $'string', re-evaluate in order to
    # drop the additional quoting.  See also: http://www.mail-archive.com/
    # bash-completion-devel@lists.alioth.debian.org/msg01942.html
    [[ ${!2} == \$* ]] && eval $2=${!2}
} # _quote_readline_by_ref()


# This function performs file and directory completion. It's better than
# simply using 'compgen -f', because it honours spaces in filenames.
# @param $1  If `-d', complete only on directories.  Otherwise filter/pick only
#            completions with `.$1' and the uppercase version of it as file
#            extension.
#
_filedir()
{
    local IFS=$'\n'

    _tilde "$cur" || return

    local -a toks
    local x tmp

    x=$( compgen -d -- "$cur" ) &&
    while read -r tmp; do
        toks+=( "$tmp" )
    done <<< "$x"

    if [[ "$1" != -d ]]; then
        local quoted
        _quote_readline_by_ref "$cur" quoted

        # Munge xspec to contain uppercase version too
        # http://thread.gmane.org/gmane.comp.shells.bash.bugs/15294/focus=15306
        local xspec=${1:+"!*.@($1|${1^^})"}
        x=$( compgen -f -X "$xspec" -- $quoted ) &&
        while read -r tmp; do
            toks+=( "$tmp" )
        done <<< "$x"

        # Try without filter if it failed to produce anything and configured to
        [[ -n ${COMP_FILEDIR_FALLBACK:-} && -n "$1" && ${#toks[@]} -lt 1 ]] && \
            x=$( compgen -f -- $quoted ) &&
            while read -r tmp; do
                toks+=( "$tmp" )
            done <<< "$x"
    fi

    if [[ ${#toks[@]} -ne 0 ]]; then
        # 2>/dev/null for direct invocation, e.g. in the _filedir unit test
        compopt -o filenames 2>/dev/null
        COMPREPLY+=( "${toks[@]}" )
    fi
} # _filedir()


# This function splits $cur=--foo=bar into $prev=--foo, $cur=bar, making it
# easier to support both "--foo bar" and "--foo=bar" style completions.
# `=' should have been removed from COMP_WORDBREAKS when setting $cur for
# this to be useful.
# Returns 0 if current option was split, 1 otherwise.
#
_split_longopt()
{
    if [[ "$cur" == --?*=* ]]; then
        # Cut also backslash before '=' in case it ended up there
        # for some reason.
        prev="${cur%%?(\\)=*}"
        cur="${cur#*=}"
        return 0
    fi

    return 1
}

# Complete variables.
# @return  True (0) if variables were completed,
#          False (> 0) if not.
_variables()
{
    if [[ $cur =~ ^(\$(\{[!#]?)?)([A-Za-z0-9_]*)$ ]]; then
        # Completing $var / ${var / ${!var / ${#var
        if [[ $cur == \${* ]]; then
            local arrs vars
            vars=( $( compgen -A variable -P ${BASH_REMATCH[1]} -S '}' -- ${BASH_REMATCH[3]} ) ) && \
            arrs=( $( compgen -A arrayvar -P ${BASH_REMATCH[1]} -S '[' -- ${BASH_REMATCH[3]} ) )
            if [[ ${#vars[@]} -eq 1 && $arrs ]]; then
                # Complete ${arr with ${array[ if there is only one match, and that match is an array variable
                compopt -o nospace
                COMPREPLY+=( ${arrs[*]} )
            else
                # Complete ${var with ${variable}
                COMPREPLY+=( ${vars[*]} )
            fi
        else
            # Complete $var with $variable
            COMPREPLY+=( $( compgen -A variable -P '$' -- "${BASH_REMATCH[3]}" ) )
        fi
        return 0
    elif [[ $cur =~ ^(\$\{[#!]?)([A-Za-z0-9_]*)\[([^]]*)$ ]]; then
        # Complete ${array[i with ${array[idx]}
        local IFS=$'\n'
        COMPREPLY+=( $( compgen -W '$(printf %s\\n "${!'${BASH_REMATCH[2]}'[@]}")' \
            -P "${BASH_REMATCH[1]}${BASH_REMATCH[2]}[" -S ']}' -- "${BASH_REMATCH[3]}" ) )
        # Complete ${arr[@ and ${arr[*
        if [[ ${BASH_REMATCH[3]} == [@*] ]]; then
            COMPREPLY+=( "${BASH_REMATCH[1]}${BASH_REMATCH[2]}[${BASH_REMATCH[3]}]}" )
        fi
        __ltrim_colon_completions "$cur"    # array indexes may have colons
        return 0
    elif [[ $cur =~ ^\$\{[#!]?[A-Za-z0-9_]*\[.*\]$ ]]; then
        # Complete ${array[idx] with ${array[idx]}
        COMPREPLY+=( "$cur}" )
        __ltrim_colon_completions "$cur"
        return 0
    else
        case $prev in
            TZ)
                cur=/usr/share/zoneinfo/$cur
                _filedir
                for i in ${!COMPREPLY[@]}; do
                    if [[ ${COMPREPLY[i]} == *.tab ]]; then
                        unset 'COMPREPLY[i]'
                        continue
                    elif [[ -d ${COMPREPLY[i]} ]]; then
                        COMPREPLY[i]+=/
                        compopt -o nospace
                    fi
                    COMPREPLY[i]=${COMPREPLY[i]#/usr/share/zoneinfo/}
                done
                return 0
                ;;
        esac
    fi
    return 1
}

# Initialize completion and deal with various general things: do file
# and variable completion where appropriate, and adjust prev, words,
# and cword as if no redirections exist so that completions do not
# need to deal with them.  Before calling this function, make sure
# cur, prev, words, and cword are local, ditto split if you use -s.
#
# Options:
#     -n EXCLUDE  Passed to _get_comp_words_by_ref -n with redirection chars
#     -e XSPEC    Passed to _filedir as first arg for stderr redirections
#     -o XSPEC    Passed to _filedir as first arg for other output redirections
#     -i XSPEC    Passed to _filedir as first arg for stdin redirections
#     -s          Split long options with _split_longopt, implies -n =
# @return  True (0) if completion needs further processing,
#          False (> 0) no further processing is necessary.
#
_init_completion()
{
    local exclude= flag outx errx inx OPTIND=1

    while getopts "n:e:o:i:s" flag "$@"; do
        case $flag in
            n) exclude+=$OPTARG ;;
            e) errx=$OPTARG ;;
            o) outx=$OPTARG ;;
            i) inx=$OPTARG ;;
            s) split=false ; exclude+== ;;
        esac
    done

    # For some reason completion functions are not invoked at all by
    # bash (at least as of 4.1.7) after the command line contains an
    # ampersand so we don't get a chance to deal with redirections
    # containing them, but if we did, hopefully the below would also
    # do the right thing with them...

    COMPREPLY=()
    local redir="@(?([0-9])<|?([0-9&])>?(>)|>&)"
    _get_comp_words_by_ref -n "$exclude<>&" cur prev words cword

    # Complete variable names.
    _variables && return 1

    # Complete on files if current is a redirect possibly followed by a
    # filename, e.g. ">foo", or previous is a "bare" redirect, e.g. ">".
    if [[ $cur == $redir* || $prev == $redir ]]; then
        local xspec
        case $cur in
            2'>'*) xspec=$errx ;;
            *'>'*) xspec=$outx ;;
            *'<'*) xspec=$inx ;;
            *)
                case $prev in
                    2'>'*) xspec=$errx ;;
                    *'>'*) xspec=$outx ;;
                    *'<'*) xspec=$inx ;;
                esac
                ;;
        esac
        cur="${cur##$redir}"
        _filedir $xspec
        return 1
    fi

    # Remove all redirections so completions don't have to deal with them.
    local i skip
    for (( i=1; i < ${#words[@]}; )); do
        if [[ ${words[i]} == $redir* ]]; then
            # If "bare" redirect, remove also the next word (skip=2).
            [[ ${words[i]} == $redir ]] && skip=2 || skip=1
            words=( "${words[@]:0:i}" "${words[@]:i+skip}" )
            [[ $i -le $cword ]] && cword=$(( cword - skip ))
        else
            i=$(( ++i ))
        fi
    done

    [[ $cword -le 0 ]] && return 1
    prev=${words[cword-1]}

    [[ ${split-} ]] && _split_longopt && split=true

    return 0
}

# Helper function for _parse_help and _parse_usage.
__parse_options()
{
    local option option2 i IFS=$' \t\n,/|'

    # Take first found long option, or first one (short) if not found.
    option=
    local -a array
    read -a array <<<"$1"
    for i in "${array[@]}"; do
        case "$i" in
            ---*) break ;;
            --?*) option=$i ; break ;;
            -?*)  [[ $option ]] || option=$i ;;
            *)    break ;;
        esac
    done
    [[ $option ]] || return

    IFS=$' \t\n' # affects parsing of the regexps below...

    # Expand --[no]foo to --foo and --nofoo etc
    if [[ $option =~ (\[((no|dont)-?)\]). ]]; then
        option2=${option/"${BASH_REMATCH[1]}"/}
        option2=${option2%%[<{().[]*}
        printf '%s\n' "${option2/=*/=}"
        option=${option/"${BASH_REMATCH[1]}"/"${BASH_REMATCH[2]}"}
    fi

    option=${option%%[<{().[]*}
    printf '%s\n' "${option/=*/=}"
}

# Parse GNU style help output of the given command.
# @param $1  command; if "-", read from stdin and ignore rest of args
# @param $2  command options (default: --help)
#
_parse_help()
{
    eval local cmd=$( quote "$1" )
    local line
    { case $cmd in
        -) cat ;;
        *) LC_ALL=C "$( dequote "$cmd" )" ${2:---help} 2>&1 ;;
      esac } \
    | while read -r line; do

        [[ $line == *([[:blank:]])-* ]] || continue
        # transform "-f FOO, --foo=FOO" to "-f , --foo=FOO" etc
        while [[ $line =~ \
            ((^|[^-])-[A-Za-z0-9?][[:space:]]+)\[?[A-Z0-9]+\]? ]]; do
            line=${line/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"}
        done
        __parse_options "${line// or /, }"

    done
}

# Parse BSD style usage output (options in brackets) of the given command.
# @param $1  command; if "-", read from stdin and ignore rest of args
# @param $2  command options (default: --usage)
#
_parse_usage()
{
    eval local cmd=$( quote "$1" )
    local line match option i char
    { case $cmd in
        -) cat ;;
        *) LC_ALL=C "$( dequote "$cmd" )" ${2:---usage} 2>&1 ;;
      esac } \
    | while read -r line; do

        while [[ $line =~ \[[[:space:]]*(-[^]]+)[[:space:]]*\] ]]; do
            match=${BASH_REMATCH[0]}
            option=${BASH_REMATCH[1]}
            case $option in
                -?(\[)+([a-zA-Z0-9?]))
                    # Treat as bundled short options
                    for (( i=1; i < ${#option}; i++ )); do
                        char=${option:i:1}
                        [[ $char != '[' ]] && printf '%s\n' -$char
                    done
                    ;;
                *)
                    __parse_options "$option"
                    ;;
            esac
            line=${line#*"$match"}
        done

    done
}

# This function completes on signal names (minus the SIG prefix)
# @param $1 prefix
_signals()
{
    local -a sigs=( $( compgen -P "$1" -A signal "SIG${cur#$1}" ) )
    COMPREPLY+=( "${sigs[@]/#${1}SIG/${1}}" )
}

# This function completes on known mac addresses
#
_mac_addresses()
{
    local re='\([A-Fa-f0-9]\{2\}:\)\{5\}[A-Fa-f0-9]\{2\}'
    local PATH="$PATH:/sbin:/usr/sbin"

    # Local interfaces
    # - ifconfig on Linux: HWaddr or ether
    # - ifconfig on FreeBSD: ether
    # - ip link: link/ether
    COMPREPLY+=( $( \
        { LC_ALL=C ifconfig -a || ip link show; } 2>/dev/null | command sed -ne \
        "s/.*[[:space:]]HWaddr[[:space:]]\{1,\}\($re\)[[:space:]].*/\1/p" -ne \
        "s/.*[[:space:]]HWaddr[[:space:]]\{1,\}\($re\)[[:space:]]*$/\1/p" -ne \
        "s|.*[[:space:]]\(link/\)\{0,1\}ether[[:space:]]\{1,\}\($re\)[[:space:]].*|\2|p" -ne \
        "s|.*[[:space:]]\(link/\)\{0,1\}ether[[:space:]]\{1,\}\($re\)[[:space:]]*$|\2|p"
        ) )

    # ARP cache
    COMPREPLY+=( $( { arp -an || ip neigh show; } 2>/dev/null | command sed -ne \
        "s/.*[[:space:]]\($re\)[[:space:]].*/\1/p" -ne \
        "s/.*[[:space:]]\($re\)[[:space:]]*$/\1/p" ) )

    # /etc/ethers
    COMPREPLY+=( $( command sed -ne \
        "s/^[[:space:]]*\($re\)[[:space:]].*/\1/p" /etc/ethers 2>/dev/null ) )

    COMPREPLY=( $( compgen -W '${COMPREPLY[@]}' -- "$cur" ) )
    __ltrim_colon_completions "$cur"
}

# This function completes on configured network interfaces
#
_configured_interfaces()
{
    if [[ -f /etc/debian_version ]]; then
        # Debian system
        COMPREPLY=( $( compgen -W "$( command sed -ne 's|^iface \([^ ]\{1,\}\).*$|\1|p'\
            /etc/network/interfaces /etc/network/interfaces.d/* 2>/dev/null )" \
            -- "$cur" ) )
    elif [[ -f /etc/SuSE-release ]]; then
        # SuSE system
        COMPREPLY=( $( compgen -W "$( printf '%s\n' \
            /etc/sysconfig/network/ifcfg-* | \
            command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p' )" -- "$cur" ) )
    elif [[ -f /etc/pld-release ]]; then
        # PLD Linux
        COMPREPLY=( $( compgen -W "$( command ls -B \
            /etc/sysconfig/interfaces | \
            command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p' )" -- "$cur" ) )
    else
        # Assume Red Hat
        COMPREPLY=( $( compgen -W "$( printf '%s\n' \
            /etc/sysconfig/network-scripts/ifcfg-* | \
            command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p' )" -- "$cur" ) )
    fi
}

# Local IP addresses.
#
_ip_addresses()
{
    local PATH=$PATH:/sbin
    COMPREPLY+=( $( compgen -W \
        "$( { LC_ALL=C ifconfig -a || ip addr show; } 2>/dev/null | command sed -ne \
            's/.*addr:\([^[:space:]]*\).*/\1/p' -ne \
            's|.*inet[[:space:]]\{1,\}\([^[:space:]/]*\).*|\1|p' )" \
        -- "$cur" ) )
}

# This function completes on available kernels
#
_kernel_versions()
{
    COMPREPLY=( $( compgen -W '$( command ls /lib/modules )' -- "$cur" ) )
}

# This function completes on all available network interfaces
# -a: restrict to active interfaces only
# -w: restrict to wireless interfaces only
#
_available_interfaces()
{
    local PATH=$PATH:/sbin

    COMPREPLY=( $( {
        if [[ ${1:-} == -w ]]; then
            iwconfig
        elif [[ ${1:-} == -a ]]; then
            ifconfig || ip link show up
        else
            ifconfig -a || ip link show
        fi
    } 2>/dev/null | awk \
        '/^[^ \t]/ { if ($1 ~ /^[0-9]+:/) { print $2 } else { print $1 } }' ) )

    COMPREPLY=( $( compgen -W '${COMPREPLY[@]/%[[:punct:]]/}' -- "$cur" ) )
}

# Echo number of CPUs, falling back to 1 on failure.
_ncpus()
{
    local var=NPROCESSORS_ONLN
    [[ $OSTYPE == *linux* ]] && var=_$var
    local n=$( getconf $var 2>/dev/null )
    printf %s ${n:-1}
}

# Perform tilde (~) completion
# @return  True (0) if completion needs further processing,
#          False (> 0) if tilde is followed by a valid username, completions
#          are put in COMPREPLY and no further processing is necessary.
_tilde()
{
    local result=0
    if [[ $1 == \~* && $1 != */* ]]; then
        # Try generate ~username completions
        COMPREPLY=( $( compgen -P '~' -u -- "${1#\~}" ) )
        result=${#COMPREPLY[@]}
        # 2>/dev/null for direct invocation, e.g. in the _tilde unit test
        [[ $result -gt 0 ]] && compopt -o filenames 2>/dev/null
    fi
    return $result
}


# Expand variable starting with tilde (~)
# We want to expand ~foo/... to /home/foo/... to avoid problems when
# word-to-complete starting with a tilde is fed to commands and ending up
# quoted instead of expanded.
# Only the first portion of the variable from the tilde up to the first slash
# (~../) is expanded.  The remainder of the variable, containing for example
# a dollar sign variable ($) or asterisk (*) is not expanded.
# Example usage:
#
#    $ v="~"; __expand_tilde_by_ref v; echo "$v"
#
# Example output:
#
#       v                  output
#    --------         ----------------
#    ~                /home/user
#    ~foo/bar         /home/foo/bar
#    ~foo/$HOME       /home/foo/$HOME
#    ~foo/a  b        /home/foo/a  b
#    ~foo/*           /home/foo/*
#
# @param $1  Name of variable (not the value of the variable) to expand
__expand_tilde_by_ref()
{
    if [[ ${!1} == \~* ]]; then
        eval $1=$(printf ~%q "${!1#\~}")
    fi
} # __expand_tilde_by_ref()


# This function expands tildes in pathnames
#
_expand()
{
    # Expand ~username type directory specifications.  We want to expand
    # ~foo/... to /home/foo/... to avoid problems when $cur starting with
    # a tilde is fed to commands and ending up quoted instead of expanded.

    if [[ "$cur" == \~*/* ]]; then
        __expand_tilde_by_ref cur
    elif [[ "$cur" == \~* ]]; then
        _tilde "$cur" || eval COMPREPLY[0]=$(printf ~%q "${COMPREPLY[0]#\~}")
        return ${#COMPREPLY[@]}
    fi
}

# This function completes on process IDs.
# AIX and Solaris ps prefers X/Open syntax.
[[ $OSTYPE == *@(solaris|aix)* ]] &&
_pids()
{
    COMPREPLY=( $( compgen -W '$( command ps -efo pid | command sed 1d )' -- "$cur" ))
} ||
_pids()
{
    COMPREPLY=( $( compgen -W '$( command ps axo pid= )' -- "$cur" ) )
}

# This function completes on process group IDs.
# AIX and SunOS prefer X/Open, all else should be BSD.
[[ $OSTYPE == *@(solaris|aix)* ]] &&
_pgids()
{
    COMPREPLY=( $( compgen -W '$( command ps -efo pgid | command sed 1d )' -- "$cur" ))
} ||
_pgids()
{
    COMPREPLY=( $( compgen -W '$( command ps axo pgid= )' -- "$cur" ))
}

# This function completes on process names.
# AIX and SunOS prefer X/Open, all else should be BSD.
# @param $1 if -s, don't try to avoid truncated command names
[[ $OSTYPE == *@(solaris|aix)* ]] &&
_pnames()
{
    COMPREPLY=( $( compgen -X '<defunct>' -W '$( command ps -efo comm | \
        command sed -e 1d -e "s:.*/::" -e "s/^-//" | sort -u )' -- "$cur" ) )
} ||
_pnames()
{
    if [[ "$1" == -s ]]; then
        COMPREPLY=( $( compgen -X '<defunct>' \
            -W '$( command ps axo comm | command sed -e 1d )' -- "$cur" ) )
    else
        # FIXME: completes "[kblockd/0]" to "0". Previously it was completed
        # to "kblockd" which isn't correct either. "kblockd/0" would be
        # arguably most correct, but killall from psmisc 22 treats arguments
        # containing "/" specially unless -r is given so that wouldn't quite
        # work either. Perhaps it'd be best to not complete these to anything
        # for now.
        COMPREPLY=( $( compgen -X '<defunct>' -W '$( command ps axo command= | command sed -e \
            "s/ .*//" -e \
            "s:.*/::" -e \
            "s/:$//" -e \
            "s/^[[(-]//" -e \
            "s/[])]$//" | sort -u )' -- "$cur" ) )
    fi
}

# This function completes on user IDs
#
_uids()
{
    if type getent &>/dev/null; then
        COMPREPLY=( $( compgen -W '$( getent passwd | cut -d: -f3 )' -- "$cur" ) )
    elif type perl &>/dev/null; then
        COMPREPLY=( $( compgen -W '$( perl -e '"'"'while (($uid) = (getpwent)[2]) { print $uid . "\n" }'"'"' )' -- "$cur" ) )
    else
        # make do with /etc/passwd
        COMPREPLY=( $( compgen -W '$( cut -d: -f3 /etc/passwd )' -- "$cur" ) )
    fi
}

# This function completes on group IDs
#
_gids()
{
    if type getent &>/dev/null; then
        COMPREPLY=( $( compgen -W '$( getent group | cut -d: -f3 )' \
            -- "$cur" ) )
    elif type perl &>/dev/null; then
        COMPREPLY=( $( compgen -W '$( perl -e '"'"'while (($gid) = (getgrent)[2]) { print $gid . "\n" }'"'"' )' -- "$cur" ) )
    else
        # make do with /etc/group
        COMPREPLY=( $( compgen -W '$( cut -d: -f3 /etc/group )' -- "$cur" ) )
    fi
}

# Glob for matching various backup files.
#
_backup_glob='@(#*#|*@(~|.@(bak|orig|rej|swp|dpkg*|rpm@(orig|new|save))))'

# Complete on xinetd services
#
_xinetd_services()
{
    local xinetddir=/etc/xinetd.d
    if [[ -d $xinetddir ]]; then
        local IFS=$' \t\n' reset=$(shopt -p nullglob); shopt -s nullglob
        local -a svcs=( $( printf '%s\n' $xinetddir/!($_backup_glob) ) )
        $reset
        COMPREPLY+=( $( compgen -W '${svcs[@]#$xinetddir/}' -- "$cur" ) )
    fi
}

# This function completes on services
#
_services()
{
    local sysvdirs
    _sysvdirs

    local IFS=$' \t\n' reset=$(shopt -p nullglob); shopt -s nullglob
    COMPREPLY=( \
        $( printf '%s\n' ${sysvdirs[0]}/!($_backup_glob|functions|README) ) )
    $reset

    COMPREPLY+=( $( systemctl list-units --full --all 2>/dev/null | \
        awk '$1 ~ /\.service$/ { sub("\\.service$", "", $1); print $1 }' ) )

    if [[ -x /sbin/upstart-udev-bridge ]]; then
        COMPREPLY+=( $( initctl list 2>/dev/null | cut -d' ' -f1 ) )
    fi

    COMPREPLY=( $( compgen -W '${COMPREPLY[@]#${sysvdirs[0]}/}' -- "$cur" ) )
}

# This completes on a list of all available service scripts for the
# 'service' command and/or the SysV init.d directory, followed by
# that script's available commands
#
_service()
{
    local cur prev words cword
    _init_completion || return

    # don't complete past 2nd token
    [[ $cword -gt 2 ]] && return

    if [[ $cword -eq 1 && $prev == ?(*/)service ]]; then
        _services
        [[ -e /etc/mandrake-release ]] && _xinetd_services
    else
        local sysvdirs
        _sysvdirs
        COMPREPLY=( $( compgen -W '`command sed -e "y/|/ /" \
            -ne "s/^.*\(U\|msg_u\)sage.*{\(.*\)}.*$/\2/p" \
            ${sysvdirs[0]}/${prev##*/} 2>/dev/null` start stop' -- "$cur" ) )
    fi
} &&
complete -F _service service
_sysvdirs
for svcdir in ${sysvdirs[@]}; do
    for svc in $svcdir/!($_backup_glob); do
        [[ -x $svc ]] && complete -F _service $svc
    done
done
unset svc svcdir sysvdirs

# This function completes on modules
#
_modules()
{
    local modpath
    modpath=/lib/modules/$1
    COMPREPLY=( $( compgen -W "$( command ls -RL $modpath 2>/dev/null | \
        command sed -ne 's/^\(.*\)\.k\{0,1\}o\(\.[gx]z\)\{0,1\}$/\1/p' )" -- "$cur" ) )
}

# This function completes on installed modules
#
_installed_modules()
{
    COMPREPLY=( $( compgen -W "$( PATH="$PATH:/sbin" lsmod | \
        awk '{if (NR != 1) print $1}' )" -- "$1" ) )
}

# This function completes on user or user:group format; as for chown and cpio.
#
# The : must be added manually; it will only complete usernames initially.
# The legacy user.group format is not supported.
#
# @param $1  If -u, only return users/groups the user has access to in
#            context of current completion.
_usergroup()
{
    if [[ $cur == *\\\\* || $cur == *:*:* ]]; then
        # Give up early on if something seems horribly wrong.
        return
    elif [[ $cur == *\\:* ]]; then
        # Completing group after 'user\:gr<TAB>'.
        # Reply with a list of groups prefixed with 'user:', readline will
        # escape to the colon.
        local prefix
        prefix=${cur%%*([^:])}
        prefix=${prefix//\\}
        local mycur="${cur#*[:]}"
        if [[ $1 == -u ]]; then
            _allowed_groups "$mycur"
        else
            local IFS=$'\n'
            COMPREPLY=( $( compgen -g -- "$mycur" ) )
        fi
        COMPREPLY=( $( compgen -P "$prefix" -W "${COMPREPLY[@]}" ) )
    elif [[ $cur == *:* ]]; then
        # Completing group after 'user:gr<TAB>'.
        # Reply with a list of unprefixed groups since readline with split on :
        # and only replace the 'gr' part
        local mycur="${cur#*:}"
        if [[ $1 == -u ]]; then
            _allowed_groups "$mycur"
        else
            local IFS=$'\n'
            COMPREPLY=( $( compgen -g -- "$mycur" ) )
        fi
    else
        # Completing a partial 'usernam<TAB>'.
        #
        # Don't suffix with a : because readline will escape it and add a
        # slash. It's better to complete into 'chown username ' than 'chown
        # username\:'.
        if [[ $1 == -u ]]; then
            _allowed_users "$cur"
        else
            local IFS=$'\n'
            COMPREPLY=( $( compgen -u -- "$cur" ) )
        fi
    fi
}

_allowed_users()
{
    if _complete_as_root; then
        local IFS=$'\n'
        COMPREPLY=( $( compgen -u -- "${1:-$cur}" ) )
    else
        local IFS=$'\n '
        COMPREPLY=( $( compgen -W \
            "$( id -un 2>/dev/null || whoami 2>/dev/null )" -- "${1:-$cur}" ) )
    fi
}

_allowed_groups()
{
    if _complete_as_root; then
        local IFS=$'\n'
        COMPREPLY=( $( compgen -g -- "$1" ) )
    else
        local IFS=$'\n '
        COMPREPLY=( $( compgen -W \
            "$( id -Gn 2>/dev/null || groups 2>/dev/null )" -- "$1" ) )
    fi
}

# This function completes on valid shells
#
_shells()
{
    local shell rest
    while read -r shell rest; do
        [[ $shell == /* && $shell == "$cur"* ]] && COMPREPLY+=( $shell )
    done 2>/dev/null < /etc/shells
}

# This function completes on valid filesystem types
#
_fstypes()
{
    local fss

    if [[ -e /proc/filesystems ]]; then
        # Linux
        fss="$( cut -d$'\t' -f2 /proc/filesystems )
            $( awk '! /\*/ { print $NF }' /etc/filesystems 2>/dev/null )"
    else
        # Generic
        fss="$( awk '/^[ \t]*[^#]/ { print $3 }' /etc/fstab 2>/dev/null )
            $( awk '/^[ \t]*[^#]/ { print $3 }' /etc/mnttab 2>/dev/null )
            $( awk '/^[ \t]*[^#]/ { print $4 }' /etc/vfstab 2>/dev/null )
            $( awk '{ print $1 }' /etc/dfs/fstypes 2>/dev/null )
            $( [[ -d /etc/fs ]] && command ls /etc/fs )"
    fi

    [[ -n $fss ]] && COMPREPLY+=( $( compgen -W "$fss" -- "$cur" ) )
}

# Get real command.
# - arg: $1  Command
# - stdout:  Filename of command in PATH with possible symbolic links resolved.
#            Empty string if command not found.
# - return:  True (0) if command found, False (> 0) if not.
_realcommand()
{
    type -P "$1" > /dev/null && {
        if type -p realpath > /dev/null; then
            realpath "$(type -P "$1")"
        elif type -p greadlink > /dev/null; then
            greadlink -f "$(type -P "$1")"
        elif type -p readlink > /dev/null; then
            readlink -f "$(type -P "$1")"
        else
            type -P "$1"
        fi
    }
}

# This function returns the first argument, excluding options
# @param $1 chars  Characters out of $COMP_WORDBREAKS which should
#     NOT be considered word breaks. See __reassemble_comp_words_by_ref.
_get_first_arg()
{
    local i

    arg=
    for (( i=1; i < COMP_CWORD; i++ )); do
        if [[ "${COMP_WORDS[i]}" != -* ]]; then
            arg=${COMP_WORDS[i]}
            break
        fi
    done
}


# This function counts the number of args, excluding options
# @param $1 chars  Characters out of $COMP_WORDBREAKS which should
#     NOT be considered word breaks. See __reassemble_comp_words_by_ref.
_count_args()
{
    local i cword words
    __reassemble_comp_words_by_ref "$1" words cword

    args=1
    for i in "${words[@]:1:cword-1}"; do
        [[ "$i" != -* ]] && args=$(($args+1))
    done
}

# This function completes on PCI IDs
#
_pci_ids()
{
    COMPREPLY+=( $( compgen -W \
        "$( PATH="$PATH:/sbin" lspci -n | awk '{print $3}')" -- "$cur" ) )
}

# This function completes on USB IDs
#
_usb_ids()
{
    COMPREPLY+=( $( compgen -W \
        "$( PATH="$PATH:/sbin" lsusb | awk '{print $6}' )" -- "$cur" ) )
}

# CD device names
_cd_devices()
{
    COMPREPLY+=( $( compgen -f -d -X "!*/?([amrs])cd*" -- "${cur:-/dev/}" ) )
}

# DVD device names
_dvd_devices()
{
    COMPREPLY+=( $( compgen -f -d -X "!*/?(r)dvd*" -- "${cur:-/dev/}" ) )
}

# TERM environment variable values
_terms()
{
    COMPREPLY+=( $( compgen -W \
        "$( command sed -ne 's/^\([^[:space:]#|]\{2,\}\)|.*/\1/p' /etc/termcap \
            2>/dev/null )" -- "$cur" ) )
    COMPREPLY+=( $( compgen -W "$( { toe -a 2>/dev/null || toe 2>/dev/null; } \
        | awk '{ print $1 }' | sort -u )" -- "$cur" ) )
}

# a little help for FreeBSD ports users
[[ $OSTYPE == *freebsd* ]] && complete -W 'index search fetch fetch-list
    extract patch configure build install reinstall deinstall clean
    clean-depends kernel buildworld' make

# This function provides simple user@host completion
#
_user_at_host()
{
    local cur prev words cword
    _init_completion -n : || return

    if [[ $cur == *@* ]]; then
        _known_hosts_real "$cur"
    else
        COMPREPLY=( $( compgen -u -S @ -- "$cur" ) )
        compopt -o nospace
    fi
}
shopt -u hostcomplete && complete -F _user_at_host talk ytalk finger

# NOTE: Using this function as a helper function is deprecated.  Use
#       `_known_hosts_real' instead.
_known_hosts()
{
    local cur prev words cword
    _init_completion -n : || return

    # NOTE: Using `_known_hosts' as a helper function and passing options
    #       to `_known_hosts' is deprecated: Use `_known_hosts_real' instead.
    local options
    [[ "$1" == -a || "$2" == -a ]] && options=-a
    [[ "$1" == -c || "$2" == -c ]] && options+=" -c"
    _known_hosts_real $options -- "$cur"
} # _known_hosts()

# Helper function to locate ssh included files in configs
# This function look for the "Include" keyword in ssh config files and include
# them recursively adding each result to the config variable
_included_ssh_config_files()
{
    [[ $# -lt 1 ]] && echo "error: $FUNCNAME: missing mandatory argument CONFIG"
    local configfile i f
    configfile=$1
    local included=$( command sed -ne 's/^[[:blank:]]*[Ii][Nn][Cc][Ll][Uu][Dd][Ee][[:blank:]]\{1,\}\([^#%]*\)\(#.*\)\{0,1\}$/\1/p' "${configfile}" )
    for i in ${included[@]}; do
        # Check the origin of $configfile to complete relative included paths on included
        # files according to ssh_config(5):
        #  "[...] Files without absolute paths are assumed to be in ~/.ssh if included in a user
        #   configuration file or /etc/ssh if included from the system configuration file.[...]"
        if ! [[ "$i" =~ ^\~.*|^\/.* ]]; then
            if [[ "$configfile" =~ ^\/etc\/ssh.* ]]; then
                i="/etc/ssh/$i"
            else
                i="$HOME/.ssh/$i"
            fi
        fi
        __expand_tilde_by_ref i
        # In case the expanded variable contains multiple paths
        for f in ${i}; do
            if [ -r $f ]; then
                config+=( "$f" )
                # The Included file is processed to look for Included files in itself
                _included_ssh_config_files $f
            fi
        done
    done
} # _included_ssh_config_files()

# Helper function for completing _known_hosts.
# This function performs host completion based on ssh's config and known_hosts
# files, as well as hostnames reported by avahi-browse if
# COMP_KNOWN_HOSTS_WITH_AVAHI is set to a non-empty value.  Also hosts from
# HOSTFILE (compgen -A hostname) are added, unless
# COMP_KNOWN_HOSTS_WITH_HOSTFILE is set to an empty value.
# Usage: _known_hosts_real [OPTIONS] CWORD
# Options:  -a             Use aliases from ssh config files
#           -c             Use `:' suffix
#           -F configfile  Use `configfile' for configuration settings
#           -p PREFIX      Use PREFIX
#           -4             Filter IPv6 addresses from results
#           -6             Filter IPv4 addresses from results
# Return: Completions, starting with CWORD, are added to COMPREPLY[]
_known_hosts_real()
{
    local configfile flag prefix
    local cur curd awkcur user suffix aliases i host ipv4 ipv6
    local -a kh khd config

    # TODO remove trailing %foo from entries

    local OPTIND=1
    while getopts "ac46F:p:" flag "$@"; do
        case $flag in
            a) aliases='yes' ;;
            c) suffix=':' ;;
            F) configfile=$OPTARG ;;
            p) prefix=$OPTARG ;;
            4) ipv4=1 ;;
            6) ipv6=1 ;;
        esac
    done
    [[ $# -lt $OPTIND ]] && echo "error: $FUNCNAME: missing mandatory argument CWORD"
    cur=${!OPTIND}; let "OPTIND += 1"
    [[ $# -ge $OPTIND ]] && echo "error: $FUNCNAME("$@"): unprocessed arguments:"\
    $(while [[ $# -ge $OPTIND ]]; do printf '%s\n' ${!OPTIND}; shift; done)

    [[ $cur == *@* ]] && user=${cur%@*}@ && cur=${cur#*@}
    kh=()

    # ssh config files
    if [[ -n $configfile ]]; then
        [[ -r $configfile ]] && config+=( "$configfile" )
    else
        for i in /etc/ssh/ssh_config ~/.ssh/config ~/.ssh2/config; do
            [[ -r $i ]] && config+=( "$i" )
        done
    fi

    # "Include" keyword in ssh config files
    for i in "${config[@]}"; do
        _included_ssh_config_files "$i"
    done

    # Known hosts files from configs
    if [[ ${#config[@]} -gt 0 ]]; then
        local OIFS=$IFS IFS=$'\n' j
        local -a tmpkh
        # expand paths (if present) to global and user known hosts files
        # TODO(?): try to make known hosts files with more than one consecutive
        #          spaces in their name work (watch out for ~ expansion
        #          breakage! Alioth#311595)
        tmpkh=( $( awk 'sub("^[ \t]*([Gg][Ll][Oo][Bb][Aa][Ll]|[Uu][Ss][Ee][Rr])[Kk][Nn][Oo][Ww][Nn][Hh][Oo][Ss][Tt][Ss][Ff][Ii][Ll][Ee][ \t]+", "") { print $0 }' "${config[@]}" | sort -u ) )
        IFS=$OIFS
        for i in "${tmpkh[@]}"; do
            # First deal with quoted entries...
            while [[ $i =~ ^([^\"]*)\"([^\"]*)\"(.*)$ ]]; do
                i=${BASH_REMATCH[1]}${BASH_REMATCH[3]}
                j=${BASH_REMATCH[2]}
                __expand_tilde_by_ref j # Eval/expand possible `~' or `~user'
                [[ -r $j ]] && kh+=( "$j" )
            done
            # ...and then the rest.
            for j in $i; do
                __expand_tilde_by_ref j # Eval/expand possible `~' or `~user'
                [[ -r $j ]] && kh+=( "$j" )
            done
        done
    fi

    if [[ -z $configfile ]]; then
        # Global and user known_hosts files
        for i in /etc/ssh/ssh_known_hosts /etc/ssh/ssh_known_hosts2 \
            /etc/known_hosts /etc/known_hosts2 ~/.ssh/known_hosts \
            ~/.ssh/known_hosts2; do
            [[ -r $i ]] && kh+=( "$i" )
        done
        for i in /etc/ssh2/knownhosts ~/.ssh2/hostkeys; do
            [[ -d $i ]] && khd+=( "$i"/*pub )
        done
    fi

    # If we have known_hosts files to use
    if [[ ${#kh[@]} -gt 0 || ${#khd[@]} -gt 0 ]]; then
        # Escape slashes and dots in paths for awk
        awkcur=${cur//\//\\\/}
        awkcur=${awkcur//\./\\\.}
        curd=$awkcur

        if [[ "$awkcur" == [0-9]*[.:]* ]]; then
            # Digits followed by a dot or a colon - just search for that
            awkcur="^$awkcur[.:]*"
        elif [[ "$awkcur" == [0-9]* ]]; then
            # Digits followed by no dot or colon - search for digits followed
            # by a dot or a colon
            awkcur="^$awkcur.*[.:]"
        elif [[ -z $awkcur ]]; then
            # A blank - search for a dot, a colon, or an alpha character
            awkcur="[a-z.:]"
        else
            awkcur="^$awkcur"
        fi

        if [[ ${#kh[@]} -gt 0 ]]; then
            # FS needs to look for a comma separated list
            COMPREPLY+=( $( awk 'BEGIN {FS=","}
            /^\s*[^|\#]/ {
            sub("^@[^ ]+ +", ""); \
            sub(" .*$", ""); \
            for (i=1; i<=NF; ++i) { \
            sub("^\\[", "", $i); sub("\\](:[0-9]+)?$", "", $i); \
            if ($i !~ /[*?]/ && $i ~ /'"$awkcur"'/) {print $i} \
            }}' "${kh[@]}" 2>/dev/null ) )
        fi
        if [[ ${#khd[@]} -gt 0 ]]; then
            # Needs to look for files called
            # .../.ssh2/key_22_<hostname>.pub
            # dont fork any processes, because in a cluster environment,
            # there can be hundreds of hostkeys
            for i in "${khd[@]}" ; do
                if [[ "$i" == *key_22_$curd*.pub && -r "$i" ]]; then
                    host=${i/#*key_22_/}
                    host=${host/%.pub/}
                    COMPREPLY+=( $host )
                fi
            done
        fi

        # apply suffix and prefix
        for (( i=0; i < ${#COMPREPLY[@]}; i++ )); do
            COMPREPLY[i]=$prefix$user${COMPREPLY[i]}$suffix
        done
    fi

    # append any available aliases from ssh config files
    if [[ ${#config[@]} -gt 0 && -n "$aliases" ]]; then
        local hosts=$( command sed -ne 's/^[[:blank:]]*[Hh][Oo][Ss][Tt][[:blank:]]\{1,\}\([^#*?%]*\)\(#.*\)\{0,1\}$/\1/p' "${config[@]}" )
        COMPREPLY+=( $( compgen -P "$prefix$user" \
            -S "$suffix" -W "$hosts" -- "$cur" ) )
    fi

    # Add hosts reported by avahi-browse, if desired and it's available.
    if [[ ${COMP_KNOWN_HOSTS_WITH_AVAHI:-} ]] && \
        type avahi-browse &>/dev/null; then
        # The original call to avahi-browse also had "-k", to avoid lookups
        # into avahi's services DB. We don't need the name of the service, and
        # if it contains ";", it may mistify the result. But on Gentoo (at
        # least), -k wasn't available (even if mentioned in the manpage) some
        # time ago, so...
        COMPREPLY+=( $( compgen -P "$prefix$user" -S "$suffix" -W \
            "$( avahi-browse -cpr _workstation._tcp 2>/dev/null | \
                awk -F';' '/^=/ { print $7 }' | sort -u )" -- "$cur" ) )
    fi

    # Add hosts reported by ruptime.
    COMPREPLY+=( $( compgen -W \
        "$( ruptime 2>/dev/null | awk '!/^ruptime:/ { print $1 }' )" \
        -- "$cur" ) )

    # Add results of normal hostname completion, unless
    # `COMP_KNOWN_HOSTS_WITH_HOSTFILE' is set to an empty value.
    if [[ -n ${COMP_KNOWN_HOSTS_WITH_HOSTFILE-1} ]]; then
        COMPREPLY+=(
            $( compgen -A hostname -P "$prefix$user" -S "$suffix" -- "$cur" ) )
    fi

    if [[ $ipv4 ]]; then
        COMPREPLY=( "${COMPREPLY[@]/*:*$suffix/}" )
    fi
    if [[ $ipv6 ]]; then
        COMPREPLY=( "${COMPREPLY[@]/+([0-9]).+([0-9]).+([0-9]).+([0-9])$suffix/}" )
    fi
    if [[ $ipv4 || $ipv6 ]]; then
        for i in ${!COMPREPLY[@]}; do
            [[ ${COMPREPLY[i]} ]] || unset -v COMPREPLY[i]
        done
    fi

    __ltrim_colon_completions "$prefix$user$cur"

} # _known_hosts_real()
complete -F _known_hosts traceroute traceroute6 tracepath tracepath6 \
    fping fping6 telnet rsh rlogin ftp dig mtr ssh-installkeys showmount

# This meta-cd function observes the CDPATH variable, so that cd additionally
# completes on directories under those specified in CDPATH.
#
_cd()
{
    local cur prev words cword
    _init_completion || return

    local IFS=$'\n' i j k

    compopt -o filenames

    # Use standard dir completion if no CDPATH or parameter starts with /,
    # ./ or ../
    if [[ -z "${CDPATH:-}" || "$cur" == ?(.)?(.)/* ]]; then
        _filedir -d
        return
    fi

    local -r mark_dirs=$(_rl_enabled mark-directories && echo y)
    local -r mark_symdirs=$(_rl_enabled mark-symlinked-directories && echo y)

    # we have a CDPATH, so loop on its contents
    for i in ${CDPATH//:/$'\n'}; do
        # create an array of matched subdirs
        k="${#COMPREPLY[@]}"
        for j in $( compgen -d -- $i/$cur ); do
            if [[ ( $mark_symdirs && -h $j || $mark_dirs && ! -h $j ) && ! -d ${j#$i/} ]]; then
                j+="/"
            fi
            COMPREPLY[k++]=${j#$i/}
        done
    done

    _filedir -d

    if [[ ${#COMPREPLY[@]} -eq 1 ]]; then
        i=${COMPREPLY[0]}
        if [[ "$i" == "$cur" && $i != "*/" ]]; then
            COMPREPLY[0]="${i}/"
        fi
    fi

    return
}
if shopt -q cdable_vars; then
    complete -v -F _cd -o nospace cd pushd
else
    complete -F _cd -o nospace cd pushd
fi

# a wrapper method for the next one, when the offset is unknown
_command()
{
    local offset i

    # find actual offset, as position of the first non-option
    offset=1
    for (( i=1; i <= COMP_CWORD; i++ )); do
        if [[ "${COMP_WORDS[i]}" != -* ]]; then
            offset=$i
            break
        fi
    done
    _command_offset $offset
}

# A meta-command completion function for commands like sudo(8), which need to
# first complete on a command, then complete according to that command's own
# completion definition.
#
_command_offset()
{
    # rewrite current completion context before invoking
    # actual command completion

    # find new first word position, then
    # rewrite COMP_LINE and adjust COMP_POINT
    local word_offset=$1 i j
    for (( i=0; i < $word_offset; i++ )); do
        for (( j=0; j <= ${#COMP_LINE}; j++ )); do
            [[ "$COMP_LINE" == "${COMP_WORDS[i]}"* ]] && break
            COMP_LINE=${COMP_LINE:1}
            ((COMP_POINT--))
        done
        COMP_LINE=${COMP_LINE#"${COMP_WORDS[i]}"}
        ((COMP_POINT-=${#COMP_WORDS[i]}))
    done

    # shift COMP_WORDS elements and adjust COMP_CWORD
    for (( i=0; i <= COMP_CWORD - $word_offset; i++ )); do
        COMP_WORDS[i]=${COMP_WORDS[i+$word_offset]}
    done
    for (( i; i <= COMP_CWORD; i++ )); do
        unset 'COMP_WORDS[i]'
    done
    ((COMP_CWORD -= $word_offset))

    COMPREPLY=()
    local cur
    _get_comp_words_by_ref cur

    if [[ $COMP_CWORD -eq 0 ]]; then
        local IFS=$'\n'
        compopt -o filenames
        COMPREPLY=( $( compgen -d -c -- "$cur" ) )
    else
        local cmd=${COMP_WORDS[0]} compcmd=${COMP_WORDS[0]}
        local cspec=$( complete -p $cmd 2>/dev/null )

        # If we have no completion for $cmd yet, see if we have for basename
        if [[ ! $cspec && $cmd == */* ]]; then
            cspec=$( complete -p ${cmd##*/} 2>/dev/null )
            [[ $cspec ]] && compcmd=${cmd##*/}
        fi
        # If still nothing, just load it for the basename
        if [[ ! $cspec ]]; then
            compcmd=${cmd##*/}
            _completion_loader $compcmd
            cspec=$( complete -p $compcmd 2>/dev/null )
        fi

        if [[ -n $cspec ]]; then
            if [[ ${cspec#* -F } != $cspec ]]; then
                # complete -F <function>

                # get function name
                local func=${cspec#*-F }
                func=${func%% *}

                if [[ ${#COMP_WORDS[@]} -ge 2 ]]; then
                    $func $cmd "${COMP_WORDS[${#COMP_WORDS[@]}-1]}" "${COMP_WORDS[${#COMP_WORDS[@]}-2]}"
                else
                    $func $cmd "${COMP_WORDS[${#COMP_WORDS[@]}-1]}"
                fi

                # restore initial compopts
                local opt
                while [[ $cspec == *" -o "* ]]; do
                    # FIXME: should we take "+o opt" into account?
                    cspec=${cspec#*-o }
                    opt=${cspec%% *}
                    compopt -o $opt
                    cspec=${cspec#$opt}
                done
            else
                cspec=${cspec#complete}
                cspec=${cspec%%$compcmd}
                COMPREPLY=( $( eval compgen "$cspec" -- '$cur' ) )
            fi
        elif [[ ${#COMPREPLY[@]} -eq 0 ]]; then
            # XXX will probably never happen as long as completion loader loads
            #     *something* for every command thrown at it ($cspec != empty)
            _minimal
        fi
    fi
}
complete -F _command aoss command do else eval exec ltrace nice nohup padsp \
    then time tsocks vsound xargs

_root_command()
{
    local PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin
    local root_command=$1
    _command
}
complete -F _root_command fakeroot gksu gksudo kdesudo really

# Return true if the completion should be treated as running as root
_complete_as_root()
{
    [[ $EUID -eq 0 || ${root_command:-} ]]
}

_longopt()
{
    local cur prev words cword split
    _init_completion -s || return

    case "${prev,,}" in
        --help|--usage|--version)
            return
            ;;
        --*dir*)
            _filedir -d
            return
            ;;
        --*file*|--*path*)
            _filedir
            return
            ;;
        --+([-a-z0-9_]))
            local argtype=$( LC_ALL=C $1 --help 2>&1 | command sed -ne \
                "s|.*$prev\[\{0,1\}=[<[]\{0,1\}\([-A-Za-z0-9_]\{1,\}\).*|\1|p" )
            case ${argtype,,} in
                *dir*)
                    _filedir -d
                    return
                    ;;
                *file*|*path*)
                    _filedir
                    return
                    ;;
            esac
            ;;
    esac

    $split && return

    if [[ "$cur" == -* ]]; then
        COMPREPLY=( $( compgen -W "$( LC_ALL=C $1 --help 2>&1 | \
            command sed -ne 's/.*\(--[-A-Za-z0-9]\{1,\}=\{0,1\}\).*/\1/p' | sort -u )" \
            -- "$cur" ) )
        [[ $COMPREPLY == *= ]] && compopt -o nospace
    elif [[ "$1" == @(rmdir|chroot) ]]; then
        _filedir -d
    else
        [[ "$1" == mkdir ]] && compopt -o nospace
        _filedir
    fi
}
# makeinfo and texi2dvi are defined elsewhere.
complete -F _longopt a2ps awk base64 bash bc bison cat chroot colordiff cp \
    csplit cut date df diff dir du enscript env expand fmt fold gperf \
    grep grub head irb ld ldd less ln ls m4 md5sum mkdir mkfifo mknod \
    mv netstat nl nm objcopy objdump od paste pr ptx readelf rm rmdir \
    sed seq sha{,1,224,256,384,512}sum shar sort split strip sum tac tail tee \
    texindex touch tr uname unexpand uniq units vdir wc who

declare -A _xspecs
_filedir_xspec()
{
    local cur prev words cword
    _init_completion || return

    _tilde "$cur" || return

    local IFS=$'\n' xspec=${_xspecs[${1##*/}]} tmp
    local -a toks

    toks=( $(
        compgen -d -- "$(quote_readline "$cur")" | {
        while read -r tmp; do
            printf '%s\n' $tmp
        done
        }
        ))

    # Munge xspec to contain uppercase version too
    # http://thread.gmane.org/gmane.comp.shells.bash.bugs/15294/focus=15306
    eval xspec="${xspec}"
    local matchop=!
    if [[ $xspec == !* ]]; then
        xspec=${xspec#!}
        matchop=@
    fi
    xspec="$matchop($xspec|${xspec^^})"

    toks+=( $(
        eval compgen -f -X "'!$xspec'" -- "\$(quote_readline "\$cur")" | {
        while read -r tmp; do
            [[ -n $tmp ]] && printf '%s\n' $tmp
        done
        }
        ))

    if [[ ${#toks[@]} -ne 0 ]]; then
        compopt -o filenames
        COMPREPLY=( "${toks[@]}" )
    fi
}

_install_xspec()
{
    local xspec=$1 cmd
    shift
    for cmd in $@; do
        _xspecs[$cmd]=$xspec
    done
}
# bzcmp, bzdiff, bz*grep, bzless, bzmore intentionally not here, see Debian: #455510
_install_xspec '!*.?(t)bz?(2)' bunzip2 bzcat pbunzip2 pbzcat lbunzip2 lbzcat
_install_xspec '!*.@(zip|[egjsw]ar|exe|pk3|wsz|zargo|xpi|s[tx][cdiw]|sx[gm]|o[dt][tspgfc]|od[bm]|oxt|epub|apk|ipa|do[ct][xm]|p[op]t[mx]|xl[st][xm]|pyz)' unzip zipinfo
_install_xspec '*.Z' compress znew
# zcmp, zdiff, z*grep, zless, zmore intentionally not here, see Debian: #455510
_install_xspec '!*.@(Z|[gGd]z|t[ag]z)' gunzip zcat
_install_xspec '!*.@(Z|[gGdz]z|t[ag]z)' unpigz
_install_xspec '!*.Z' uncompress
# lzcmp, lzdiff intentionally not here, see Debian: #455510
_install_xspec '!*.@(tlz|lzma)' lzcat lzegrep lzfgrep lzgrep lzless lzmore unlzma
_install_xspec '!*.@(?(t)xz|tlz|lzma)' unxz xzcat
_install_xspec '!*.lrz' lrunzip
_install_xspec '!*.@(gif|jp?(e)g|miff|tif?(f)|pn[gm]|p[bgp]m|bmp|xpm|ico|xwd|tga|pcx)' ee
_install_xspec '!*.@(gif|jp?(e)g|tif?(f)|png|p[bgp]m|bmp|x[bp]m|rle|rgb|pcx|fits|pm|svg)' qiv
_install_xspec '!*.@(gif|jp?(e)g?(2)|j2[ck]|jp[2f]|tif?(f)|png|p[bgp]m|bmp|x[bp]m|rle|rgb|pcx|fits|pm|?(e)ps)' xv
_install_xspec '!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?(.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv kghostview
_install_xspec '!*.@(dvi|DVI)?(.@(gz|Z|bz2))' xdvi kdvi
_install_xspec '!*.dvi' dvips dviselect dvitype dvipdf advi dvipdfm dvipdfmx
_install_xspec '!*.[pf]df' acroread gpdf xpdf
_install_xspec '!*.@(?(e)ps|pdf)' kpdf
_install_xspec '!*.@(okular|@(?(e|x)ps|?(E|X)PS|[pf]df|[PF]DF|dvi|DVI|cb[rz]|CB[RZ]|djv?(u)|DJV?(U)|dvi|DVI|gif|jp?(e)g|miff|tif?(f)|pn[gm]|p[bgp]m|bmp|xpm|ico|xwd|tga|pcx|GIF|JP?(E)G|MIFF|TIF?(F)|PN[GM]|P[BGP]M|BMP|XPM|ICO|XWD|TGA|PCX|epub|EPUB|odt|ODT|fb?(2)|FB?(2)|mobi|MOBI|g3|G3|chm|CHM)?(.?(gz|GZ|bz2|BZ2)))' okular
_install_xspec '!*.pdf' epdfview pdfunite
_install_xspec '!*.@(cb[rz7t]|djv?(u)|?(e)ps|pdf)' zathura
_install_xspec '!*.@(?(e)ps|pdf)' ps2pdf ps2pdf12 ps2pdf13 ps2pdf14 ps2pdfwr
_install_xspec '!*.texi*' makeinfo texi2html
_install_xspec '!*.@(?(la)tex|texi|dtx|ins|ltx|dbj)' tex latex slitex jadetex pdfjadetex pdftex pdflatex texi2dvi xetex xelatex luatex lualatex
_install_xspec '!*.mp3' mpg123 mpg321 madplay
_install_xspec '!*@(.@(mp?(e)g|MP?(E)G|wm[av]|WM[AV]|avi|AVI|asf|vob|VOB|bin|dat|divx|DIVX|vcd|ps|pes|fli|flv|FLV|fxm|FXM|viv|rm|ram|yuv|mov|MOV|qt|QT|web[am]|WEB[AM]|mp[234]|MP[234]|m?(p)4[av]|M?(P)4[AV]|mkv|MKV|og[agmv]|OG[AGMV]|t[ps]|T[PS]|m2t?(s)|M2T?(S)|mts|MTS|wav|WAV|flac|FLAC|asx|ASX|mng|MNG|srt|m[eo]d|M[EO]D|s[3t]m|S[3T]M|it|IT|xm|XM)|+([0-9]).@(vdr|VDR))?(.part)' xine aaxine fbxine
_install_xspec '!*@(.@(mp?(e)g|MP?(E)G|wm[av]|WM[AV]|avi|AVI|asf|vob|VOB|bin|dat|divx|DIVX|vcd|ps|pes|fli|flv|FLV|fxm|FXM|viv|rm|ram|yuv|mov|MOV|qt|QT|web[am]|WEB[AM]|mp[234]|MP[234]|m?(p)4[av]|M?(P)4[AV]|mkv|MKV|og[agmv]|OG[AGMV]|t[ps]|T[PS]|m2t?(s)|M2T?(S)|mts|MTS|wav|WAV|flac|FLAC|asx|ASX|mng|MNG|srt|m[eo]d|M[EO]D|s[3t]m|S[3T]M|it|IT|xm|XM|iso|ISO)|+([0-9]).@(vdr|VDR))?(.part)' kaffeine dragon
_install_xspec '!*.@(avi|asf|wmv)' aviplay
_install_xspec '!*.@(rm?(j)|ra?(m)|smi?(l))' realplay
_install_xspec '!*.@(mpg|mpeg|avi|mov|qt)' xanim
_install_xspec '!*.@(og[ag]|m3u|flac|spx)' ogg123
_install_xspec '!*.@(mp3|ogg|pls|m3u)' gqmpeg freeamp
_install_xspec '!*.fig' xfig
_install_xspec '!*.@(mid?(i)|cmf)' playmidi
_install_xspec '!*.@(mid?(i)|rmi|rcp|[gr]36|g18|mod|xm|it|x3m|s[3t]m|kar)' timidity
_install_xspec '!*.@(669|abc|am[fs]|d[bs]m|dmf|far|it|mdl|m[eo]d|mid?(i)|mt[2m]|oct|okt?(a)|p[st]m|s[3t]m|ult|umx|wav|xm)' modplugplay modplug123
_install_xspec '*.@([ao]|so|so.!(conf|*/*)|[rs]pm|gif|jp?(e)g|mp3|mp?(e)g|avi|asf|ogg|class)' vi vim gvim rvim view rview rgvim rgview gview emacs xemacs sxemacs kate kwrite
_install_xspec '!*.@(zip|z|gz|tgz)' bzme
# konqueror not here on purpose, it's more than a web/html browser
_install_xspec '!*.@(?([xX]|[sS])[hH][tT][mM]?([lL]))' netscape mozilla lynx galeon dillo elinks amaya epiphany
_install_xspec '!*.@(?([xX]|[sS])[hH][tT][mM]?([lL])|[pP][dD][fF])' firefox mozilla-firefox iceweasel google-chrome chromium-browser
_install_xspec '!*.@(sxw|stw|sxg|sgl|doc?([mx])|dot?([mx])|rtf|txt|htm|html|?(f)odt|ott|odm|pdf)' oowriter lowriter
_install_xspec '!*.@(sxi|sti|pps?(x)|ppt?([mx])|pot?([mx])|?(f)odp|otp)' ooimpress loimpress
_install_xspec '!*.@(sxc|stc|xls?([bmx])|xlw|xlt?([mx])|[ct]sv|?(f)ods|ots)' oocalc localc
_install_xspec '!*.@(sxd|std|sda|sdd|?(f)odg|otg)' oodraw lodraw
_install_xspec '!*.@(sxm|smf|mml|odf)' oomath lomath
_install_xspec '!*.odb' oobase lobase
_install_xspec '!*.[rs]pm' rpm2cpio
_install_xspec '!*.aux' bibtex
_install_xspec '!*.po' poedit gtranslator kbabel lokalize
_install_xspec '!*.@([Pp][Rr][Gg]|[Cc][Ll][Pp])' harbour gharbour hbpp
_install_xspec '!*.[Hh][Rr][Bb]' hbrun
_install_xspec '!*.ly' lilypond ly2dvi
_install_xspec '!*.@(dif?(f)|?(d)patch)?(.@([gx]z|bz2|lzma))' cdiff
_install_xspec '!@(*.@(ks|jks|jceks|p12|pfx|bks|ubr|gkr|cer|crt|cert|p7b|pkipath|pem|p10|csr|crl)|cacerts)' portecle
_install_xspec '!*.@(mp[234c]|og[ag]|@(fl|a)ac|m4[abp]|spx|tta|w?(a)v|wma|aif?(f)|asf|ape)' kid3 kid3-qt
unset -f _install_xspec

# Minimal completion to use as fallback in _completion_loader.
_minimal()
{
    local cur prev words cword split
    _init_completion -s || return
    $split && return
    _filedir
}
# Complete the empty string to allow completion of '>', '>>', and '<' on < 4.3
# http://lists.gnu.org/archive/html/bug-bash/2012-01/msg00045.html
complete -F _minimal ''


__load_completion()
{
    local -a dirs=( ${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions )
    local OIFS=$IFS IFS=: dir cmd="${1##*/}" compfile
    for dir in ${XDG_DATA_DIRS:-/usr/local/share:/usr/share}; do
        dirs+=( $dir/bash-completion/completions )
    done
    IFS=$OIFS

    if [[ $BASH_SOURCE == */* ]]; then
        dirs+=( "${BASH_SOURCE%/*}/completions" )
    else
        dirs+=( ./completions )
    fi

    for dir in "${dirs[@]}"; do
        for compfile in "$cmd" "$cmd.bash" "_$cmd"; do
            compfile="$dir/$compfile"
            # Avoid trying to source dirs; https://bugzilla.redhat.com/903540
            [[ -f "$compfile" ]] && . "$compfile" &>/dev/null && return 0
        done
    done

    # Look up simple "xspec" completions
    [[ "${_xspecs[$cmd]}" ]] && complete -F _filedir_xspec "$cmd" && return 0

    return 1
}

# set up dynamic completion loading
_completion_loader()
{
    # $1=_EmptycmD_ already for empty cmds in bash 4.3, set to it for earlier
    local cmd="${1:-_EmptycmD_}"

    __load_completion "$cmd" && return 124

    # Need to define *something*, otherwise there will be no completion at all.
    complete -F _minimal -- "$cmd" && return 124
} &&
complete -D -F _completion_loader

# Function for loading and calling functions from dynamically loaded
# completion files that may not have been sourced yet.
# @param $1 completion file to load function from in case it is missing
# @param $2... function and its arguments
_xfunc()
{
    set -- "$@"
    local srcfile=$1
    shift
    declare -F $1 &>/dev/null || {
        __load_completion "$srcfile"
    }
    "$@"
}

# source compat completion directory definitions
compat_dir=${BASH_COMPLETION_COMPAT_DIR:-/etc/bash_completion.d}
if [[ -d $compat_dir && -r $compat_dir && -x $compat_dir ]]; then
    for i in "$compat_dir"/*; do
        [[ ${i##*/} != @($_backup_glob|Makefile*|$_blacklist_glob) \
            && -f $i && -r $i ]] && . "$i"
    done
fi
unset compat_dir i _blacklist_glob

# source user completion file
user_completion=${BASH_COMPLETION_USER_FILE:-~/.bash_completion}
[[ ${BASH_SOURCE[0]} != $user_completion && -r $user_completion ]] \
    && . $user_completion
unset user_completion

unset -f have
unset have

set $BASH_COMPLETION_ORIGINAL_V_VALUE
unset BASH_COMPLETION_ORIGINAL_V_VALUE

# ex: filetype=sh


# Copyright (C) 2016-2017 Cyker Way
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

# Function: Debug.
_debug() {
    echo
    echo "COMP_WORDS=("
    for x in "${COMP_WORDS[@]}"; do
        echo "'$x'"
    done
    echo ")"
    echo "#COMP_WORDS=${#COMP_WORDS[@]}"
    echo "COMP_CWORD=${COMP_CWORD}"
    echo "COMP_LINE='${COMP_LINE}'"
    echo "COMP_POINT=${COMP_POINT}"
    echo
}

# Register: Function return value.
_retval=0

# Refcnt: Use alias iff _use_alias == 0.
_use_alias=0

# Function: Test whether the given array contains the given element.
# Usage: _in <elem> <arr_elem_0> <arr_elem_1> ...
_in () {
    for e in "${@:2}"; do
        [[ "$e" == "$1" ]] && return 0
    done
    return 1
}

# Function: Expand aliases in a command line.
# Return: Difference of #COMP_WORDS (before/after expansion).
_expand_alias () {
    local beg="$1" end="$2" ignore="$3" n_used="$4"; shift 4
    local used=( "${@:1:$n_used}" ); shift $n_used

    if [[ "$beg" -eq "$end" ]]; then
        # Case 1: Range is empty.
        _retval=0
    elif [[ -n "$ignore" ]] && [[ "$beg" -eq "$ignore" ]]; then
        # Case 2: Beginning index is ignored. Pass it.
        _expand_alias "$(( $beg+1 ))" "$end" "$ignore" "${#used[@]}" "${used[@]}"
        _retval="$_retval"
    elif ! ( alias "${COMP_WORDS[$beg]}" &>/dev/null ) || ( _in "${COMP_WORDS[$beg]}" "${used[@]}" ); then
        # Case 3: Command is not an alias or is an used alias.
        _retval=0
    else
        # Case 4: Command is an unused alias.

        # Expand 1 level of command alias.
        local cmd="${COMP_WORDS[$beg]}"
        local str0="$( alias "$cmd" | sed -E 's/[^=]*=//' | xargs )"

        # The old way of word breaking (using xargs) is not accurate enough.
        #
        # For example:
        #
        # > alias foo='docker run -u $(id -u $USER):$(id -g $USER)'
        #
        # will be broken as:
        #
        # > docker
        # > run
        # > -u
        # > $(id
        # > -u
        # > $USER):$(id
        # > -g
        # > $USER)
        #
        # while the correct word breaking is:
        #
        # > docker
        # > run
        # > -u
        # > $(id -u $USER)
        # > :
        # > $(id -g $USER)
        #
        # Therefore we implement our own word breaking which gives the correct
        # behavior in this case. It takes the alias body ($str0) as input,
        # breaks it into words and stores them in an array ($words0).
        {
            # An array that will contain the broken words.
            words0=()

            # Create a temp stack which tracks quoting while breaking words.
            local sta=()

            # Examine each char of $str0.
            local i=0 j=0
            for (( j=0;j<${#str0};j++ )); do
                if [[ $' \t\n' == *"${str0:j:1}"* ]]; then
                    # Whitespace chars.
                    if [[ ${#sta[@]} -eq 0 ]]; then
                        if [[ $i -lt $j ]]; then
                            words0+=("${str0:i:j-i}")
                        fi
                        (( i=j+1 ))
                    fi
                elif [[ "><=;|&:" == *"${str0:j:1}"* ]]; then
                    # Break chars.
                    if [[ ${#sta[@]} -eq 0 ]]; then
                        if [[ $i -lt $j ]]; then
                            words0+=("${str0:i:j-i}")
                        fi
                        words0+=("${str0:j:1}")
                        (( i=j+1 ))
                    fi
                elif [[ "\"')}" == *"${str0:j:1}"* ]]; then
                    # Right quote chars.
                    if [[ ${#sta[@]} -ne 0 ]] && [[ "${str0:j:1}" == ${sta[-1]} ]]; then
                        unset sta[-1]
                    fi
                elif [[ "\"'({" == *"${str0:j:1}"* ]]; then
                    # Left quote chars.
                    if [[ "${str0:j:1}" == "\"" ]]; then
                        sta+=("\"")
                    elif [[ "${str0:j:1}" == "'" ]]; then
                        sta+=("'")
                    elif [[ "${str0:j:1}" == "(" ]]; then
                        sta+=(")")
                    elif [[ "${str0:j:1}" == "{" ]]; then
                        sta+=("}")
                    fi
                fi
            done
            # Append the last word.
            if [[ $i -lt $j ]]; then
                words0+=("${str0:i:j-i}")
            fi

            # Unset the temp stack.
            unset sta
        }

        # Rewrite COMP_LINE and COMP_POINT.
        local i j=0
        for (( i=0; i < $beg; i++ )); do
            for (( ; j <= ${#COMP_LINE}; j++ )); do
                [[ "${COMP_LINE:j}" == "${COMP_WORDS[i]}"* ]] && break
            done
            (( j+=${#COMP_WORDS[i]} ))
        done
        for (( ; j <= ${#COMP_LINE}; j++ )); do
            [[ "${COMP_LINE:j}" == "${COMP_WORDS[i]}"* ]] && break
        done

        COMP_LINE="${COMP_LINE[@]:0:j}""$str0""${COMP_LINE[@]:j+${#cmd}}"
        if [[ $COMP_POINT -lt $j ]]; then
            :
        elif [[ $COMP_POINT -lt $(( j+${#cmd} )) ]]; then
            (( COMP_POINT=j+${#str0} ))
        else
            (( COMP_POINT+=${#str0}-${#cmd} ))
        fi

        # Rewrite COMP_WORDS and COMP_CWORD.
        COMP_WORDS=( "${COMP_WORDS[@]:0:beg}" "${words0[@]}" "${COMP_WORDS[@]:beg+1}" )
        if [[ $COMP_CWORD -lt $beg ]]; then
            :
        elif [[ $COMP_CWORD -lt $(( $beg+1 )) ]]; then
            (( COMP_CWORD=beg+${#words0[@]} ))
        else
            (( COMP_CWORD+=${#words0[@]}-1 ))
        fi

        # Rewrite ignore if it's not empty.
        # If ignore is not empty, we already know it's not equal to beg because
        # we have checked it in Case 2.
        if [[ -n "$ignore" ]] && [[ $ignore -gt $beg ]]; then
            (( ignore+=${#words0[@]}-1 ))
        fi

        # Recursively expand Part 0.
        local used0=( "${used[@]}" "$cmd" )
        _expand_alias "$beg" "$(( $beg+${#words0[@]} ))" "$ignore" "${#used0[@]}" "${used0[@]}"
        local diff0="$_retval"

        # Recursively expand Part 1.
        if [[ -n "$str0" ]] && [[ "${str0: -1}" == ' ' ]]; then
            local used1=( "${used[@]}" )
            _expand_alias "$(( $beg+${#words0[@]}+$diff0 ))" "$(( $end+${#words0[@]}-1+$diff0 ))" "$ignore" "${#used1[@]}" "${used1[@]}"
            local diff1="$_retval"
        else
            local diff1=0
        fi

        # Return value.
        _retval=$(( ${#words0[@]}-1+diff0+diff1 ))
    fi
}

# Function: Set a command's completion function to the default one.
# Users may edit this function to fit their own needs.
_set_default_completion () {
    local cmd="$1"

    case "$cmd" in
        bind)
            complete -A binding "$cmd"
            ;;
        help)
            complete -A helptopic "$cmd"
            ;;
        set)
            complete -A setopt "$cmd"
            ;;
        shopt)
            complete -A shopt "$cmd"
            ;;
        bg)
            complete -A stopped -P '"%' -S '"' "$cmd"
            ;;
        service)
            complete -F _service "$cmd"
            ;;
        unalias)
            complete -a "$cmd"
            ;;
        builtin)
            complete -b "$cmd"
            ;;
        command|type|which)
            complete -c "$cmd"
            ;;
        fg|jobs|disown)
            complete -j -P '"%' -S '"' "$cmd"
            ;;
        groups|slay|w|sux)
            complete -u "$cmd"
            ;;
        readonly|unset)
            complete -v "$cmd"
            ;;
        traceroute|traceroute6|tracepath|tracepath6|fping|fping6|telnet|rsh|\
            rlogin|ftp|dig|mtr|ssh-installkeys|showmount)
            complete -F _known_hosts "$cmd"
            ;;
        aoss|command|do|else|eval|exec|ltrace|nice|nohup|padsp|then|time|tsocks|vsound|xargs)
            complete -F _command "$cmd"
            ;;
        fakeroot|gksu|gksudo|kdesudo|really)
            complete -F _root_command "$cmd"
            ;;
        a2ps|awk|base64|bash|bc|bison|cat|chroot|colordiff|cp|csplit|cut|date|\
            df|diff|dir|du|enscript|env|expand|fmt|fold|gperf|grep|grub|head|\
            irb|ld|ldd|less|ln|ls|m4|md5sum|mkdir|mkfifo|mknod|mv|netstat|nl|\
            nm|objcopy|objdump|od|paste|pr|ptx|readelf|rm|rmdir|sed|seq|\
            sha{,1,224,256,384,512}sum|shar|sort|split|strip|sum|tac|tail|tee|\
            texindex|touch|tr|uname|unexpand|uniq|units|vdir|wc|who)
            complete -F _longopt "$cmd"
            ;;
        *)
            _completion_loader "$cmd"
            ;;
    esac
}

# Function: Programmable completion function for aliases.
_complete_alias () {
    # Get command.
    local cmd="${COMP_WORDS[0]}"

    # We expand aliases only for the original command line (i.e. the command
    # line as verbatim when user presses 'Tab'). That is to say, we expand
    # aliases only in the first call of this function. Therefore we check the
    # refcnt and expand aliases iff it's equal to 0.
    if [[ $_use_alias -eq 0 ]]; then

        # Find the range of indexes of COMP_WORDS[COMP_CWORD] in COMP_LINE. If
        # COMP_POINT lies in this range, don't expand this word because it may
        # be incomplete.
        local i j=0
        for (( i=0; i < $COMP_CWORD; i++ )); do
            for (( ; j <= ${#COMP_LINE}; j++ )); do
                [[ "${COMP_LINE:j}" == "${COMP_WORDS[i]}"* ]] && break
            done
            (( j+=${#COMP_WORDS[i]} ))
        done
        for (( ; j <= ${#COMP_LINE}; j++ )); do
            [[ "${COMP_LINE:j}" == "${COMP_WORDS[i]}"* ]] && break
        done

        # Now j is at the beginning of word COMP_WORDS[COMP_CWORD] and so the
        # range is [j, j+#COMP_WORDS[COMP_CWORD]]. Compare it with COMP_POINT.
        if [[ $j -le $COMP_POINT ]] && [[ $COMP_POINT -le $(( $j+${#COMP_WORDS[$COMP_CWORD]} )) ]]; then
            local ignore="$COMP_CWORD"
        else
            local ignore=""
        fi

        # Expand aliases.
        _expand_alias 0 "${#COMP_WORDS[@]}" "$ignore" 0
    fi

    # Increase _use_alias refcnt.
    (( _use_alias++ ))

    # Since aliases have been fully expanded, we no longer need to consider
    # aliases in the resulting command line. So we now set this command's
    # completion function to the default one (which is alias-agnostic). This
    # avoids infinite recursion when a command is aliased to itself (i.e. alias
    # ls='ls -a').
    _set_default_completion "$cmd"

    # Do actual completion.
    _command_offset 0

    # Decrease _use_alias refcnt.
    (( _use_alias-- ))

    # Reset this command's completion function to `_complete_alias`.
    complete -F _complete_alias "$cmd"
}

# Set alias completions.
#
# Uncomment and edit these lines to add your own alias completions.
#
complete -F _complete_alias pin
complete -F _complete_alias pup
complete -F _complete_alias pun

[[ -r "$HOME/bin/shell/zsh/git-completion.bash" ]] && . "$HOME/bin/shell/zsh/git-completion.bash"
