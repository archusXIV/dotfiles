This module executes the defined script and displays its output. You can find community-curated script modules in the [polybar-scripts](https://github.com/polybar/polybar-scripts) repository.

**NOTES**:  
- The module will wait for the `exec` script to finish until updating its contents. If you are launching an application, make sure you are sending it to the background by appending `&` after the line that executes the application.  
- If your script is using an infinite loop in combination with `tail = true`, the `exec-if` condition is only checked until it evaluates to true for the first time, because it is only checked before running the `exec` command and since the `exec` command never returns (because of the infinite loop), `exec-if` is never evaluated again, once the `exec` command is running. So if the `exec-if` condition at some point, while the infinite loop is running, would evaluate to false the script will not suddenly stop running and the module will not disappear.
- To be displayed on the bar, the script's output has to be newline terminated (as most commands do).
- If you want the module to disappear from the bar in some cases, your script
must produce a single empty line of output and a zero exit code.
Otherwise an outdated output is still on the bar.
See [`#504`](https://github.com/polybar/polybar/issues/504) and
[`#2861`](https://github.com/polybar/polybar/pull/2861).
- When using python scripts, the python runtime will not always immediately flush the output so that polybar can read it (see [`#793`](https://github.com/polybar/polybar/issues/793) for example). For `tail = true` scripts, this may result in the output only updating kind of randomly instead of at every print. This can be solved by running python in unbuffered mode (`python -u`)

### Basic settings
```ini
[module/pkgupdates-available]
type = custom/script

; Available tokens:
;   %counter%
; Command to be executed (using "/bin/sh -c [command]")
exec = checkforupdates

; Conditional command that, if defined, needs to exit successfully
; before the main exec command is invoked.
; Default: ""
exec-if = pgrep -x myservice

; Set this to true for scripts that continuously produce output
; If set to 'true', everytime the script produces a new line of output, the module updates.
; Otherwise, only the first line of output is considered and all later lines are discarded.
; Default: false
tail = true

; Seconds to sleep between updates
; Default: 5 (0 if `tail = true`)
interval = 90

; Interval used when the `exec` command returns with a non-zero exit code 
; If not defined, interval is used instead
; New in version 3.7.0
; Default: (same as interval)
interval-fail = 300

; Seconds to sleep between `exec-if` invocations
; If not defined, interval is used instead
; New in version 3.7.0
; Default: (same as interval)
interval-if = 180

; Set environment variables in the 'exec' script
; New in version 3.6.0
; env-NAME = VALUE
; env-FOO = BAR
```

### Additional formatting
```ini
; Available tags:
;   <label> (default)
format = <label>
format-background = #999
format-foreground = #000
format-padding = 4

; Format used when the `exec` command returns with a non-zero exit code 
; Only used with `tail = false`
; If not defined, format is used instead.
; Available tags:
;   <label-fail>
; New in version 3.6.0
; format-fail = <label-fail>

; Available tokens:
;   %output%
; Default: %output%
label = %output:0:15:...%

; Available tokens:
;   %output%
; Default: %output%
; New in version 3.6.0
label-fail = %output:0:15:...%

; Available tokens:
;   %counter%
;   %pid%
;
; "click-(left|middle|right)" will be executed using "/bin/sh -c [command]"
click-left = echo left %counter%
click-middle = echo middle %counter%
click-right = echo right %counter%
double-click-left = echo double left %counter%
double-click-middle = echo double middle %counter%
double-click-right = echo double right %counter%

; Available tokens:
;   %counter%
;   %pid%
;
; "scroll-(up|down)" will be executed using "/bin/sh -c [command]"
scroll-up = echo scroll up %counter%
scroll-down = echo scroll down %counter%
```

### Examples

You can use `exec-if` to only display output once the defined condition is met. For example:
```dosini
[module/vpn]
type = custom/script
exec = echo vpn
exec-if = pgrep -x openvpn
interval = 5
format-underline = #268bd2
format-prefix = "🖧 "
format-prefix-foreground = #5b
```

The `%pid%` token can be used to send signals to the script, allowing for multiple states. Here is an example of a date 
script with two states:
```dosini
[module/date]
type = custom/script
exec = /path/to/date.sh
tail = true
click-left = kill -USR1 %pid%
```

**Note:** `%pid%` actually refers to the `sh` process that executes the `exec` command. The shell will generally relay 
signals to the `exec` command. However if the command runs in the background it won't. In those cases you can use 
`pgrep` to find the oldest child belonging to `%pid%` and send the signal to that (child) pid:
```dosini
click-left = "kill -USR1 $(pgrep --oldest --parent %pid%)"
```

`date.sh`:
```bash
t=0
sleep_pid=0

toggle() {
    t=$(((t + 1) % 2))

    if [ "$sleep_pid" -ne 0 ]; then
        kill $sleep_pid >/dev/null 2>&1
    fi
}


trap "toggle" USR1

while true; do
    if [ $t -eq 0 ]; then
        date
    else
        date --rfc-3339=seconds
    fi
    sleep 1 &
    sleep_pid=$!
    wait
done
```
