This module uses the bspwm ipc client to display information about available monitors, desktops and layout states.

See the [Configuration wiki page](https://github.com/polybar/polybar/wiki/Configuration#global-wm-settings) for details on how to configure the `_NET_WM_STRUT_PARTIAL` values. This will allow you to update `padding_{top,bottom}` when the bar is launched.


### Accessible workspace cycling

You are able to define fallback click handlers for the whole bar window. Using those you could cycle your desktops by scrolling anywhere on the bar (except existing areas setup for the same button). You should probably disable scrolling for the module (`enable-scroll = false`) if you are using this method.

The bspwm module supports the `next` and `prev` [actions](https://polybar.readthedocs.io/user/actions.html) and will send the correct commands to bspwm to change the current workspace. 

```dosini
[bar/mybar]
; replace bspwm with the name of your bspwm module
scroll-up = #bspwm.prev
scroll-down = #bspwm.next
; Alternatively, you can send commands directly to bspwm
;scroll-up = bspc desktop -f prev.local
;scroll-down = bspc desktop -f next.local
```


### Basic settings
To override the default path to the bspwm socket file, define the environment variable `BSPWM_SOCKET`.

```ini
[module/bspwm]
type = internal/bspwm

; Only show workspaces defined on the same output as the bar
; NOTE: The bspwm and XRandR monitor names must match, which they do by default.
; But if you rename your bspwm monitors with bspc -n this option will no longer
; behave correctly.
; Default: true
pin-workspaces = true

; Output mode flags after focused state label
; Default: false
inline-mode = false

; Create click handler used to focus workspace
; Default: true
enable-click = false

; Create scroll handlers used to cycle workspaces
; Default: true
enable-scroll = false

; Set the scroll cycle direction 
; Default: true
reverse-scroll = false

; Use fuzzy (partial) matching on labels when assigning 
; icons to workspaces
; Example: code;♚ will apply the icon to all workspaces 
; containing 'code' in the label
; Default: false
fuzzy-match = true

; Only scroll through occupied workspaces
; Default: false
; New in version 3.6.0
occupied-scroll = true
```

### Additional formatting
```ini
; ws-icon-[0-9]+ = <label>;<icon>
; Note that the <label> needs to correspond with the bspwm workspace name
; Neither <label> nor <icon> can contain a semicolon (;)
ws-icon-0 = code;♚
ws-icon-1 = office;♛
ws-icon-2 = graphics;♜
ws-icon-3 = mail;♝
ws-icon-4 = web;♞
ws-icon-default = ♟

; Available tags:
;   <label-monitor>
;   <label-state> - gets replaced with <label-(focused|urgent|occupied|empty)>
;   <label-mode> - gets replaced with <label-(monocle|tiled|fullscreen|floating|locked|sticky|private)>
; Default: <label-state>
format = <label-state> <label-mode>

; Available tokens:
;   %name%
; Default: %name%
label-monitor = %name%

; If any values for label-dimmed-N are defined, the workspace/mode
; colors will get overridden with those values if the monitor is out of focus
; To only override workspaces in a specific state, use:
;   label-dimmed-focused
;   label-dimmed-occupied
;   label-dimmed-urgent
;   label-dimmed-empty
label-dimmed-foreground = #555
label-dimmed-underline = ${bar/top.background}
label-dimmed-focused-background = #f00

; Available tokens:
;   %name%
;   %icon%
;   %index%
; Default: %icon% %name%
label-focused = %icon%
label-focused-foreground = #ffffff
label-focused-background = #3f3f3f
label-focused-underline = #fba922

; Available tokens:
;   %name%
;   %icon%
;   %index%
; Default: %icon% %name%
label-occupied = %icon%
label-occupied-underline = #555555

; Available tokens:
;   %name%
;   %icon%
;   %index%
; Default: %icon% %name%
label-urgent = %icon%
label-urgent-foreground = #000000
label-urgent-background = #bd2c40
label-urgent-underline = #9b0a20

; Available tokens:
;   %name%
;   %icon%
;   %index%
; Default: %icon% %name%
label-empty = %icon%
label-empty-foreground = #55

; The following labels will be used to indicate the layout/mode
; for the focused workspace. Requires <label-mode>
;
; Available tokens:
;   None
;label-monocle = 
;label-tiled = 
;label-fullscreen = 
;label-floating = 
;label-pseudotiled = P
;label-locked = 
;label-locked-foreground = #bd2c40
;label-sticky = 
;label-sticky-foreground = #fba922
;label-private = 
;label-private-foreground = #bd2c40
;label-marked = M

; Separator in between workspaces
label-separator = |
label-separator-padding = 2
label-separator-foreground = #ffb52a
```

### Generate ws-icon list
```bash
#!/bin/bash
counter=0
bspc query -D --names | while read -r name; do
  printf 'ws-icon-%i = "%s;<insert-icon-here>"\n' $((counter++)) $name
done
```
