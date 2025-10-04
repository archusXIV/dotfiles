This module shows information about mounted filesystems.

**NOTE:** The module is currently limited to mountpoints.

### Basic settings

```ini
[module/filesystem]
type = internal/fs

; Mountpoints to display
; Default: / (new in version 3.7.0)
mount-0 = /
mount-1 = /home
mount-2 = /var

; Seconds to sleep between updates
; Default: 30
interval = 10

; Display fixed precision values
; Default: false
fixed-values = true

; Spacing (number of spaces, pixels, points) between entries
; Default: 2
spacing = 4

; Default: 90
; New in version 3.6.0
warn-percentage = 75
```

### Additional formatting
```ini
; Available tags:
;   <label-mounted> (default)
;   <bar-free>
;   <bar-used>
;   <ramp-capacity>
format-mounted = <label-mounted>

; Available tags:
;   <label-unmounted> (default)
format-unmounted = <label-unmounted>

; Format used when mountpoint %percentage_used% reaches warn-percentage
; If not defined, format-mounted is used instead.
; Available tags:
;   <label-warn>
;   <bar-free>
;   <bar-used>
;   <ramp-capacity>
; New in version 3.6.0
; format-warn = <label-warn>

; Available tokens:
;   %mountpoint%
;   %type%
;   %fsname%
;   %percentage_free%
;   %percentage_used%
;   %total%
;   %free%
;   %used%
; Default: %mountpoint% %percentage_free%%
label-mounted = %mountpoint%: %percentage_free%% of %total%

; Available tokens:
;   %mountpoint%
; Default: %mountpoint% is not mounted
label-unmounted = %mountpoint%: not mounted
label-unmounted-foreground = #55

; Available tokens:
;   %mountpoint%
;   %type%
;   %fsname%
;   %percentage_free%
;   %percentage_used%
;   %total%
;   %free%
;   %used%
; Default: %mountpoint% %percentage_free%%
; New in version 3.6.0
; label-warn = %mountpoint%: WARNING
```

If you want different customization per mountpoint, we suggest creating
multiple modules and using
[inheritance](https://github.com/polybar/polybar/wiki/Configuration#inheritance)
to reuse common configuration options:

```ini
[bar/example]
modules-left = fs-root fs-home
separator = |
separator-padding = 1

[fs-base]
type = internal/fs
fixed-values = true
label-mounted = %mountpoint%: %free%

[module/fs-root]
inherit = fs-base
mount-0 = /
label-mounted = ROOT: %free%

[module/fs-home]
inherit = fs-base
mount-0 = /home
```
