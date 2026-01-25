-- mod-version:3
-- local lsp_snippets = require 'plugins.lsp_snippets'
local snippets = require 'plugins.snippets'

snippets.add {
    trigger  = 'myb',
    info     = 'bash Shebang',
    format   = 'lsp',
    template = [[
#!/usr/bin/env bash
## This is a part of main script: mpm.

# shellcheck disable=SC2154
]]
}

snippets.add {
    trigger  = 'myc',
    info     = 'case statement',
    format   = 'lsp',
    template = [[
case "\${$1var}" in
    $2opt1)
        $3command1
    ;;
    $4opt2)
        $5command2
    ;;
    $6*)
        $7command3
    ;;
esac
]]
}

snippets.add {
    trigger  = 'myd',
    info     = 'declare an array',
    format   = 'lsp',
    template = [[
declare -a $1arrayName=(
    $2"index1"
    $3"index2"
    $4"index3"
    $5"index4"
    $6"index5"
    $7"index6"
    $8"index7"
)
]]
}

snippets.add {
    trigger  = 'myfa',
    info     = 'for loop in array',
    format   = 'lsp',
    template = [[
for $1var in "\${$2arrayName[@]}"; do
    ${3:command} \${$1var}
done
]]
}

snippets.add {
    trigger  = 'myfe',
    info     = 'loop few elements',
    format   = 'lsp',
    template = [[
for $1elm in ${2:item1} ${3:item2} ${4:item3}; do
    ${5:command} \${$1elm}
done
]]
}

snippets.add {
    trigger  = 'myfi',
    info     = 'for loop integer',
    format   = 'lsp',
    template = [[
for ((i=${1:n1};i<${2:n2};i++)); do
    ${3:echo} "\${i}"
done
]]
}

snippets.add {
    trigger  = 'func',
    info     = 'function snippet',
    format   = 'lsp',
    template = [[
_${1:functionName}() {
    ${2:body}
}
]]
}

snippets.add {
    trigger  = 'mymap',
    info     = 'mapfile snippet',
    format   = 'lsp',
    template = [[
mapfile -t ${1:arrayName} < <(${2:command})
]]
}

snippets.add {
    trigger  = 'nested',
    info     = 'nested function',
    format   = 'lsp',
    template = [[
__${1:nestedFunctionName}() (
    ${2:command}
)
]]
}

snippets.add {
    trigger  = 'mypf',
    info     = 'printf statement',
    format   = 'lsp',
    template = [[
printf '%s\\n' "$1"
]]
}

snippets.add {
    trigger  = 'mywr',
    info     = 'while read loop',
    format   = 'lsp',
    template = [[
while read -r ${2:line}; do
    ${3:command} "\${$2}"
done < "\${$1file}"
]]
}

snippets.add {
    trigger  = 'mywt',
    info     = 'while true; do',
    format   = 'lsp',
    template = [[
while true; do
    ${1:command}
done
]]
}

snippets.add {
    trigger  = 'myif',
    info     = 'if else statement',
    format   = 'lsp',
    template = [=[
if [[ ${1:condition} ]]; then
    ${2:command1}
else
    ${3:command2}
fi
]=]
}

snippets.add {
    trigger  = 'myel',
    info     = 'if elif statement',
    format   = 'lsp',
    template = [==[
if [[ ${1:condition1} ]]; then
    ${2:command1}
elif [[ ${3:condition2} ]]
    ${4:command2}
else
    ${5:command3}
fi
]==]
}

snippets.add {
    trigger  = 'myst',
    info     = 'simple test',
    format   = 'lsp',
    template = [==[
[[ ${1:condition} ]] ${2:operator} ${3:command}
]==]
}

snippets.add {
    trigger  = 'els',
    info     = 'adding else statement',
    format   = 'lsp',
    template = [[
else
    ${1:command2}
fi
]]
}

snippets.add {
    trigger  = 'thn',
    info     = 'adding then statement',
    format   = 'lsp',
    template = [[
then
    ${1:command1}
else
    ${2:command2}
fi
]]
}

