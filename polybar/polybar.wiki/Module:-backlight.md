This module shows information about the current monitor brightness setting.

The values for that are read from files in the `/sys/class/backlight/` folder.
Every folder in `/sys/class/backlight/` represents one backlight in your system
(many desktops will have no backlights at all) and in that subfolder, the
module will use the files `brightness`, `actual_brightness`, and
`max_brightness` to determine the current brightness.

Whether the `brightness` or `actual_brightness` file is used to get the current
brightness is controlled by the `use-actual-brightness` setting.
We recommend using the `actual_brightness` file (the default) because it should
get real-time updates.

However, depending on your device, the `actual_brightness` file may not hold
the correct values or may not update correctly.

### Basic settings
```ini
[module/backlight]
type = internal/backlight

; Use the following command to list available cards:
; $ ls -1 /sys/class/backlight/
; Default: first usable card in /sys/class/backlight (new in version 3.7.0)
card = intel_backlight

; Use the `/sys/class/backlight/.../actual-brightness` file
; rather than the regular `brightness` file.
; New in version 3.6.0
; Changed in version: 3.7.0: Defaults to true also on amdgpu backlights
; Default: true
use-actual-brightness = true

; Interval in seconds after which after which the current brightness is read
; (even if no update is detected).
; Use this as a fallback if brightness updates are not registering in polybar
; (which happens if the use-actual-brightness is false).
; There is no guarantee on the precisio of this timing.
; Set to 0 to turn off
; New in version 3.7.0
; Default: 0 (5 if use-actual-brightness is false)
poll-interval = 0

; Enable changing the backlight with the scroll wheel
; NOTE: This may require additional configuration on some systems. Polybar will
; write to `/sys/class/backlight/${self.card}/brightness` which requires polybar
; to have write access to that file.
; DO NOT RUN POLYBAR AS ROOT. 
; The recommended way is to add the user to the
; `video` group and give that group write-privileges for the `brightness` file.
; See the ArchWiki for more information:
; https://wiki.archlinux.org/index.php/Backlight#ACPI
; Default: false
enable-scroll = true

; Interval for changing the brightness (in percentage points).
; New in version 3.7.0
; Default: 5
scroll-interval = 10
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

### References

* [Kernel Documentation for `/sys/class/backlight/`](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/ABI/stable/sysfs-class-backlight)
