This module shows volume and mute state for Pulseaudio. It uses the specified sink in the config if available, and uses the default sink if it is not available or provided.

### Basic settings
```ini
[module/pulseaudio]
type = internal/pulseaudio

; Sink to be used, if it exists (find using `pacmd list-sinks`, name field)
; If not, uses default sink
; sink = alsa_output.pci-0000_12_00.3.analog-stereo

; Use PA_VOLUME_UI_MAX (~153%) if true, or PA_VOLUME_NORM (100%) if false
; Default: true
use-ui-max = true

; Interval for volume increase/decrease (in percent points)
; Default: 5
interval = 5

; Reverses the increment/decrement on scroll event. Set this to true if you are
; using natural scrolling option on your touchpad.
; New in version 3.7.0
; Default: false
reverse-scroll = false
```

### Additional formatting
```ini
; Available tags:
;   <label-volume> (default)
;   <ramp-volume>
;   <bar-volume>
format-volume = <ramp-volume> <label-volume>

; Available tags:
;   <label-muted> (default)
;   <ramp-volume>
;   <bar-volume>
;format-muted = <label-muted>

; Available tokens:
;   %percentage% (default)
;   %decibels%
;label-volume = %percentage%%

; Available tokens:
;   %percentage% (default)
;   %decibels%
label-muted = 🔇 muted
label-muted-foreground = #666

; Only applies if <ramp-volume> is used
ramp-volume-0 = 🔈
ramp-volume-1 = 🔉
ramp-volume-2 = 🔊

; Right and Middle click
click-right = pavucontrol
; click-middle = 

```
