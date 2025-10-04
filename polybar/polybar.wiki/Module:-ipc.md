This module lets you define hooks to be triggered when a matching ipc [action](https://polybar.readthedocs.io/user/actions.html#custom-ipc) is received.
The hook will execute its defined shell command and the output from it will be printed as the module content.

```sh
# Triggers hook-0 in ipc module named 'subscriber'
$ polybar-msg [-p pid] action subscriber hook 0
```

**NOTE:** Requires messaging support to be enabled for the parent bar: `enable-ipc = true`

### Basic settings

```ini
[module/subscriber]
type = custom/ipc

; Define the command to be executed when the hook is triggered
; Available tokens:
;   %pid% (id of the parent polybar process)
hook-0 = date
hook-1 = whoami
hook-2 = echo "Files in ${HOME}: $(ls -1a ~ | wc -l)"

; Hook to execute on launch. The index is 1-based and using
; the example below (2) `whoami` would be executed on launch.
; If 0 is specified, no hook is run on launch
; Default: 0
initial = 2
```

### Additional formatting
```ini
; Available tags:
;   <output>
;   <label> (default, new in version 3.7.0)
format = <output>
format-foreground = #f00
format-background = #fff

; Format the output of individual hooks (replace i with the number of the hook)
; Available tags:
;   <label> (default)
; New in version 3.7.0
format-i = <label>

; 
; Available tokens:
;   %output% (Output produced by the current hook)
; New in version 3.7.0
label = %output%

; Mouse actions
; Available tokens:
;   %pid% (id of the parent polybar process)
click-left =
click-middle =
click-right =
scroll-up =
scroll-down =
double-click-left =
double-click-right =
```

### Examples

Sample module with self-updating click actions:

```dosini
[module/demo]
type = custom/ipc
hook-0 = echo foobar
hook-1 = date +%s
hook-2 = whoami
format = <label>
format-1 = <label>
format-1-background = #ff0000
initial = 1
click-left = "#demo.hook.0"
click-right = "#demo.hook.1"
double-click-left = "#demo.hook.2"
```
