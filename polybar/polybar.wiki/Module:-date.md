This module shows information about the current date.

**NOTE:** This module supports most—but not all—of the formatting sequences that can be found in `man date`. For example, to display the time in 12-hour format, you can use either `%I:%M` or `%l:%M` for a 0-padded hour or a space-padded hour respectively.

Formatting sequences such as `%-I` (12-hour time without padding) will not work. Use a custom script with the `date` command as a workaround.

### Basic settings
```ini
[module/date]
type = internal/date

; Seconds to sleep between updates
; Default: 1.0
interval = 1.0

; See "https://en.cppreference.com/w/cpp/io/manip/put_time" for details on how to format the date string
; NOTE: if you want to use syntax tags here you need to use %%{...}
date = %Y-%m-%d%

; Optional time format
time = %H:%M

; if `date-alt` or `time-alt` is defined, clicking
; the module will toggle between formats
date-alt = %A, %d %B %Y
time-alt = %H:%M:%S
```

### Additional formatting
```ini
; Available tags:
;   <label> (default)
format = 🕓 <label>
format-background = #55ff3399
format-foreground = #fff

; Available tokens:
;   %date%
;   %time%
; Default: %date%
label = %date% %time%
label-font = 3
label-foreground = #9A32DB
```
