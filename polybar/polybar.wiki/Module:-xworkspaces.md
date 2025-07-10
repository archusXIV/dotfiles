### The module is still in development ❗️

Things to be done:
- Label for visible but not focused workspaces (on multiple monitors, see [`#950`](https://github.com/polybar/polybar/issues/950))
---

This module displays EWMH desktops configured by the window manager.

**NOTE**: Requires a [EWMH](https://specifications.freedesktop.org/wm-spec/wm-spec-latest.html) compatible window manager.
In particular, certain atoms need to be available on your root window (you can check this with `xprop -root <ATOM>`).
Not all atoms are required, but functionality may be limited if some of them are not supported:

* `_NET_NUMBER_OF_DESKTOPS`: Required
* `_NET_CURRENT_DESKTOP`: `label-active`
* `_NET_CLIENT_LIST`: `label-urgent`, `label-occupied`, `%nwin%`
* `_NET_DESKTOP_NAMES`: `%name%`
* `_NET_DESKTOP_VIEWPORT`: `pin-workspaces = true`

In addition, for `label-occupied`, the `_NET_WM_DESKTOP` atom needs to be set on all windows.

You can check which atoms your window manager supports by running `xprop -root _NET_SUPPORTED`.

### Basic settings
```ini
[module/ewmh]
type = internal/xworkspaces

; Only show workspaces defined on the same output as the bar
;
; Useful if you want to show monitor specific workspaces
; on different bars
;
; Default: false
pin-workspaces = true

; Groups workspaces by monitor. If set to false, workspaces are not grouped and
; appear in the order provided by the WM
; If set to false, cannot be used together with label-monitor
; New in version 3.7.0
; Default: true
group-by-monitor = false

; Create click handler used to focus desktop
; Default: true
enable-click = false

; Create scroll handlers used to cycle desktops
; Default: true
enable-scroll = false

; Reverse the scroll direction
; Default: false
; New in version 3.6.0
reverse-scroll = true
```

### Additional formatting
```ini
; icon-[0-9]+ = <desktop-name>;<icon>
; Map desktop names to some icon. The icon is then available in the %icon% token
; NOTE: The desktop name needs to match the name configured by the WM
; You can get a list of the defined desktop names using:
; $ xprop -root _NET_DESKTOP_NAMES
; NOTE: Neither <desktop-name> nor <icon> can contain a semicolon (;)
icon-0 = code;♚
icon-1 = office;♛
icon-2 = graphics;♜
icon-3 = mail;♝
icon-4 = web;♞
icon-default = ♟

; Available tags:
;   <label-monitor>
;   <label-state> - gets replaced with <label-(active|urgent|occupied|empty)>
; Default: <label-state>
format = <label-state>

; Cannot be used if group-by-monitor is false
; Available tokens:
;   %name%
; Default: %name%
label-monitor = %name%

; Used for the currently selected workspaces
; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %nwin% (New in version 3.6.0)
; Default: %icon% %name%
label-active = %icon% %name%
label-active-foreground = #ffffff
label-active-background = #3f3f3f
label-active-underline = #fba922
label-active-padding = 4

; Used for workspaces at least one window
; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %nwin% (New in version 3.6.0)
; Default: %icon% %name%
label-occupied = %icon%
label-occupied-underline = #555555

; Used for workspaces containing a window that is demanding attention (has the
; urgent bit set)
; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %nwin% (New in version 3.6.0)
; Default: %icon% %name%
label-urgent = %icon%
label-urgent-foreground = #000000
label-urgent-background = #bd2c40
label-urgent-underline = #9b0a20
label-urgent-padding = 4

; Used for workspaces without windows
; Available tokens:
;   %name%
;   %icon%
;   %index%
;   %nwin% (New in version 3.6.0)
; Default: %icon% %name%
label-empty = %icon%
label-empty-foreground = #55
label-empty-padding = 2
```
