**If this module doesn't work for you, try to use [the backlight module](https://github.com/polybar/polybar/wiki/Module:-backlight)**

---

This module shows information about the defined output's backlight level.

### Basic settings
```ini
[module/backlight]
type = internal/xbacklight

; XRandR output to get get values from
; Default: the monitor defined for the running bar
output = HDMI-1

; Create scroll handlers used to set the backlight value
; Default: true
enable-scroll = false
```

### Additional formatting
```ini
; Available tags:
;   <label> (default)
;   <ramp>
;   <bar>
format = <label>

; Available tokens:
;   %percentage% (default)
label = %percentage%%

; Only applies if <ramp> is used
ramp-0 = 🌕
ramp-1 = 🌔
ramp-2 = 🌓
ramp-3 = 🌒
ramp-4 = 🌑

; Only applies if <bar> is used
bar-width = 10
bar-indicator = |
bar-fill = ─
bar-empty = ─
```
