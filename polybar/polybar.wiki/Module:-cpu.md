This module shows information about the current CPU load.

### Basic settings
```ini
[module/cpu]
type = internal/cpu

; Seconds to sleep between updates
; Default: 1
interval = 0.5

; Default: 80
; New in version 3.6.0
warn-percentage = 95
```

### Additional formatting
```ini
; Available tags:
;   <label> (default)
;   <bar-load>
;   <ramp-load>
;   <ramp-coreload>
format = <label> <ramp-coreload>

; Format used when average CPU load (same as %percentage%) reaches warn-percentage
; If not defined, format is used instead.
; Available tags:
;   <label-warn>
;   <bar-load>
;   <ramp-load>
;   <ramp-coreload>
; New in version 3.6.0
; format-warn = <label-warn>

; Available tokens:
;   %percentage% (default) - total cpu load averaged over all cores
;   %percentage-sum% - Cumulative load on all cores
;   %percentage-cores% - load percentage for each core
;   %percentage-core[1-9]% - load percentage for specific core
label = CPU %percentage%%

; Available tokens:
;   %percentage% (default) - total cpu load averaged over all cores
;   %percentage-sum% - Cumulative load on all cores
;   %percentage-cores% - load percentage for each core
;   %percentage-core[1-9]% - load percentage for specific core
; New in version 3.6.0
label-warn = CPU %percentage%%

; Spacing (number of spaces, pixels, points) between individual per-core ramps
ramp-coreload-spacing = 1
ramp-coreload-0 = ▁
ramp-coreload-1 = ▂
ramp-coreload-2 = ▃
ramp-coreload-3 = ▄
ramp-coreload-4 = ▅
ramp-coreload-5 = ▆
ramp-coreload-6 = ▇
ramp-coreload-7 = █
```
