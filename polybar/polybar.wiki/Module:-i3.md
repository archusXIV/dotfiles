This module uses the i3 ipc to display information about workspaces and active mode.

**NOTE**: Requires the project to be built with i3 support; Check for `+i3` in `polybar -vvv`.
The module also requires the `i3` executable to be on the `PATH`.

### Accessible workspace cycling

You are able to define fallback click handlers for the whole bar window. Using those you could cycle your workspaces by scrolling anywhere on the bar (except existing areas setup for the same button). You should probably disable scrolling for the module (`enable-scroll = false`) if you are using this method.

The i3 module supports the `next` and `prev` [actions](https://polybar.readthedocs.io/user/actions.html) and will send the correct commands to i3 to change the current workspace. 

**Note:** You will need to have an i3 module in your bar for this to work.

```dosini
[bar/mybar]
; replace i3 with the name of your i3 module
scroll-up = "#i3.prev"
scroll-down = "#i3.next"
; Alternatively, you can send commands directly to i3
;scroll-up = i3-msg workspace next_on_output
;scroll-down = i3-msg workspace prev_on_output
```


### Basic settings
```ini
[module/i3]
type = internal/i3

; Only show workspaces defined on the same output as the bar
;
; Useful if you want to show monitor specific workspaces
; on different bars
;
; Default: false
pin-workspaces = true

; Show urgent workspaces regardless of whether the workspace is actually hidden 
; by pin-workspaces.
;
; Default: false
; New in version 3.6.0
show-urgent = true

; This will split the workspace name on ':'
; Default: false
strip-wsnumbers = true

; Sort the workspaces by index instead of the default
; sorting that groups the workspaces by output
; Default: false
index-sort = true

; Create click handler used to focus workspace
; Default: true
enable-click = false

; Create scroll handlers used to cycle workspaces
; Default: true
enable-scroll = false

; Wrap around when reaching the first/last workspace
; Default: true
wrapping-scroll = false

; Set the scroll cycle direction 
; Default: true
reverse-scroll = false

; Use fuzzy (partial) matching for wc-icon.
; Example: code;♚ will apply the icon to all workspaces 
; containing 'code' in the name
; Changed in version 3.7.0: Selects longest string match instead of the first match.
; Default: false
fuzzy-match = true
```

### Additional formatting
```ini
; ws-icon-[0-9]+ = <label>;<icon>
; NOTE: The <label> needs to match the name of the i3 workspace
; Neither <label> nor <icon> can contain a semicolon (;)
ws-icon-0 = 1;♚
ws-icon-1 = 2;♛
ws-icon-2 = 3;♜
ws-icon-3 = 4;♝
ws-icon-4 = 5;♞
ws-icon-default = ♟
; NOTE: You cannot skip icons, e.g. to get a ws-icon-6
; you must also define a ws-icon-5.
; NOTE: Icon will be available as the %icon% token inside label-*

; Available tags:
;   <label-state> (default) - gets replaced with <label-(focused|unfocused|visible|urgent)>
;   <label-mode> (default)
format = <label-state> <label-mode>

; Available tokens:
;   %mode%
; Default: %mode%
label-mode = %mode%
label-mode-padding = 2
label-mode-background = #e60053

; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %output%
; Default: %icon% %name%
label-focused = %index%
label-focused-foreground = #ffffff
label-focused-background = #3f3f3f
label-focused-underline = #fba922
label-focused-padding = 4

; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %output%
; Default: %icon% %name%
label-unfocused = %index%
label-unfocused-padding = 4

; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %output%
; Default: %icon% %name%
label-visible = %index%
label-visible-underline = #555555
label-visible-padding = 4

; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %output%
; Default: %icon% %name%
label-urgent = %index%
label-urgent-foreground = #000000
label-urgent-background = #bd2c40
label-urgent-padding = 4

; Separator in between workspaces
label-separator = |
label-separator-padding = 2
label-separator-foreground = #ffb52a
```

### Generate ws-icon list
```bash
#!/bin/bash
counter=0
i3-msg -t get_workspaces | tr ',' '\n' | sed -nr 's/"name":"([^"]+)"/\1/p' | while read -r name; do
  printf 'ws-icon-%i = "%s;<insert-icon-here>"\n' $((counter++)) $name
done
```
