This module shows the title of the currently focused window.

**NOTE**: Requires a WM that supports the EWMH atom `_NET_ACTIVE_WINDOW`.

### Basic settings
```ini
[module/title]
type = internal/xwindow
```

### Additional formatting
```ini
; Available tags:
;   <label> (default)
format = <label>
format-background = #f00
format-foreground = #000
format-padding = 4

; Available tokens:
;   %title%
;   %instance% (first part of the WM_CLASS atom, new in version 3.7.0)
;   %class%    (second part of the WM_CLASS atom, new in version 3.7.0)
; Default: %title%
label = %title%
label-maxlen = 50

; Used instead of label when there is no window title
; Available tokens:
;   None
label-empty = Empty
label-empty-foreground = #707880
```
