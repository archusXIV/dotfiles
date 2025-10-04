This module shows the defined content string.

### Basic settings
```ini
[module/my-text-label]
type = custom/text
```

### Additional formatting
```ini
; @deprecated Use format and/or label to define the module text
; content = Some random label

; Available tags:
;   <label> (default)
; New in version 3.7.0
format = <label>
format-background = #000
format-foreground = #fff
format-padding = 4

; No tokens available
; New in version 3.7.0
label = Some random label

; "click-(left|middle|right)" will be executed using "/bin/sh -c $COMMAND"
click-left = notify-send left
click-middle = notify-send middle
click-right = notify-send right

; "scroll-(up|down)" will be executed using "/bin/sh -c $COMMAND"
scroll-up = notify-send scroll up
scroll-down = notify-send scroll down
```
