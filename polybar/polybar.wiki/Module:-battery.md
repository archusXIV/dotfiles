This module shows information about the battery.

### Basic settings
```ini
[module/battery]
type = internal/battery

; This is useful in case the battery never reports 100% charge
; Default: 100
full-at = 99

; format-low once this charge percentage is reached
; Default: 10
; New in version 3.6.0
low-at = 5

; Use the following command to list batteries and adapters:
; $ ls -1 /sys/class/power_supply/
battery = BAT0
adapter = ADP1

; If an inotify event haven't been reported in this many
; seconds, manually poll for new values.
;
; Needed as a fallback for systems that don't report events
; on sysfs/procfs.
;
; Disable polling by setting the interval to 0.
;
; Default: 5
poll-interval = 5
```

### Additional formatting

> [!NOTE]
> The battery icons used in the examples below come from the [Font Awesome
> 6](https://fontawesome.com), namely the `Font Awesome 6 Free Solid` font.

```ini
; see "man date" for details on how to format the time string
; NOTE: if you want to use syntax tags here you need to use %%{...}
; Default: %H:%M:%S
time-format = %H:%M

; Available tags:
;   <label-charging> (default)
;   <bar-capacity>
;   <ramp-capacity>
;   <animation-charging>
format-charging = <animation-charging> <label-charging>

; Available tags:
;   <label-discharging> (default)
;   <bar-capacity>
;   <ramp-capacity>
;   <animation-discharging>
format-discharging = <ramp-capacity> <label-discharging>

; Available tags:
;   <label-full> (default)
;   <bar-capacity>
;   <ramp-capacity>
;format-full = <ramp-capacity> <label-full>

; Format used when battery level drops to low-at
; If not defined, format-discharging is used instead.
; Available tags:
;   <label-low>
;   <animation-low>
;   <bar-capacity>
;   <ramp-capacity>
; New in version 3.6.0
;format-low = <label-low> <animation-low>

; Available tokens:
;   %percentage% (default) - is set to 100 if full-at is reached
;   %percentage_raw%
;   %time%
;   %consumption% (shows current charge rate in watts)
label-charging = Charging %percentage%%

; Available tokens:
;   %percentage% (default) - is set to 100 if full-at is reached
;   %percentage_raw%
;   %time%
;   %consumption% (shows current discharge rate in watts)
label-discharging = Discharging %percentage%%

; Available tokens:
;   %percentage% (default) - is set to 100 if full-at is reached
;   %percentage_raw%
label-full = Fully charged

; Available tokens:
;   %percentage% (default) - is set to 100 if full-at is reached
;   %percentage_raw%
;   %time%
;   %consumption% (shows current discharge rate in watts)
; New in version 3.6.0
label-low = BATTERY LOW

; Only applies if <ramp-capacity> is used
ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-3 = 
ramp-capacity-4 = 

; Only applies if <bar-capacity> is used
bar-capacity-width = 10

; Only applies if <animation-charging> is used
animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-3 = 
animation-charging-4 = 
; Framerate in milliseconds
animation-charging-framerate = 750

; Only applies if <animation-discharging> is used
animation-discharging-0 = 
animation-discharging-1 = 
animation-discharging-2 = 
animation-discharging-3 = 
animation-discharging-4 = 
; Framerate in milliseconds
animation-discharging-framerate = 500

; Only applies if <animation-low> is used
; New in version 3.6.0
animation-low-0 = !
animation-low-1 = 
animation-low-framerate = 200
```


