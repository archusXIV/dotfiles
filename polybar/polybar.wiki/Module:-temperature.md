This module shows the information about the current temperature.

### Basic settings
```ini
[module/temperature]
type = internal/temperature

; Seconds to sleep between updates
; Default: 1
interval = 0.5

; Thermal zone to use
; To list all the zone types, run 
; $ for i in /sys/class/thermal/thermal_zone*; do echo "$i: $(<$i/type)"; done
; Default: 0
thermal-zone = 0

; Select thermal zone by name
; The name has to match the contents of /sys/class/thermal/thermal_zone*/type
; for the desired thermal zone.
; New in version 3.7.0
; Default: ""
zone-type = x86_pkg_temp

; Full path of temperature sysfs path
; Use `sensors` to find preferred temperature source, then run
; $ for i in /sys/class/hwmon/hwmon*/temp*_input; do echo "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*})) $(readlink -f $i)"; done
; to find path to desired file
; Default reverts to thermal zone setting
hwmon-path = /sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input

; Base temperature for where to start the ramp (in degrees celsius)
; Default: 0
base-temperature = 20

; Threshold temperature to display warning label (in degrees celsius)
; Default: 80
warn-temperature = 60
```

### Additional formatting
```ini
; Whether or not to show units next to the temperature tokens (°C, °F)
; Default: true
units = false

; Available tags:
;   <label> (default)
;   <ramp>
format = <ramp> <label>

; Available tags:
;   <label-warn> (default)
;   <ramp>
format-warn = <ramp> <label-warn>

; Available tokens:
;   %temperature% (deprecated)
;   %temperature-c%   (default, temperature in °C)
;   %temperature-f%   (temperature in °F)
;   %temperature-k%   (temperature in Kelvin, new in version 3.7.0)
label = TEMP %temperature-c%

; Available tokens:
;   %temperature% (deprecated)
;   %temperature-c%   (default, temperature in °C)
;   %temperature-f%   (temperature in °F)
;   %temperature-k%   (temperature in Kelvin, new in version 3.7.0)
label-warn = TEMP %temperature-c%
label-warn-foreground = #f00

; Requires the <ramp> tag
; The icon selection will range from `base-temperature` to `warn-temperature`,
; temperatures at and above `warn-temperature` will use the last icon
; and temperatures at and below `base-temperature` will use `ramp-0`. 
; All other icons are distributed evenly between the two temperatures.
ramp-0 = A
ramp-1 = B
ramp-2 = C
ramp-foreground = #55
```
