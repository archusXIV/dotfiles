This module shows information about the specified network interface.

**NOTE:** If you use both a wired and a wireless network, you need two module 
definitions if you want both to be displayed. For example:

> ```ini
> [module/wired-network]
> type = internal/network
> interface = eth1
>
> [module/wireless-network]
> type = internal/network
> interface = wlan1
> ```

### Basic settings
```ini
[module/network]
type = internal/network
; Name of the network interface to display. You can get the names of the
; interfaces on your machine with `ip link`
; Wireless interfaces often start with `wl` and ethernet interface with `eno` or `eth`
interface = wlan1

; If no interface is specified, polybar can detect an interface of the given type.
; If multiple are found, it will prefer running interfaces and otherwise just
; use the first one found.
; Either 'wired' or 'wireless'
; New in version 3.6.0
interface-type = wireless

; Seconds to sleep between updates
; Default: 1
interval = 3.0

; NOTE: Experimental (might change or be removed in the future)
; Test connectivity every Nth update by pinging 8.8.8.8
; In case the ping fails 'format-packetloss' is used until the next ping
; A value of 0 disables the feature
; Default: 0
;ping-interval = 3

; @deprecated: Define min width using token specifiers (%downspeed:min% and %upspeed:min%)
; Minimum output width of upload/download rate
; Default: 3
udspeed-minwidth = 5

; Accumulate values from all interfaces
; when querying for up/downspeed rate
; Default: false
accumulate-stats = true

; Consider an `UNKNOWN` interface state as up.
; Some devices like USB network adapters have 
; an unknown state, even when they're running
; Default: false
unknown-as-up = true

; The unit used for displaying network speeds
; For example if set to the empty string, a speed of 5 KB/s is displayed as 5 K
; Default: B/s
; New in version 3.6.0
speed-unit = ''
```

### Additional formatting
```ini
; Available tags:
;   <label-connected> (default)
;   <ramp-signal>
format-connected = <ramp-signal> <label-connected>

; Available tags:
;   <label-disconnected> (default)
format-disconnected = <label-disconnected>

; Used when connected, but ping fails (see ping-interval)
; Available tags:
;   <label-connected> (default)
;   <label-packetloss>
;   <animation-packetloss>
format-packetloss = <animation-packetloss> <label-connected>

; All labels support the following tokens:
;   %ifname%    [wireless+wired]
;   %local_ip%  [wireless+wired]
;   %local_ip6% [wireless+wired]
;   %essid%     [wireless]
;   %signal%    [wireless]
;   %upspeed%   [wireless+wired]
;   %downspeed% [wireless+wired]
;   %netspeed%  [wireless+wired] (%upspeed% + %downspeed%) (New in version 3.6.0)
;   %linkspeed% [wired]
;   %mac%       [wireless+wired] (New in version 3.6.0)

; Default: %ifname% %local_ip%
label-connected = %essid% %downspeed:9%
label-connected-foreground = #eefafa

; Default: (none)
label-disconnected = not connected
label-disconnected-foreground = #66ffff

; Default: (none)
;label-packetloss = %essid%
;label-packetloss-foreground = #eefafafa

; Only applies if <ramp-signal> is used
ramp-signal-0 = 😱
ramp-signal-1 = 😠
ramp-signal-2 = 😒
ramp-signal-3 = 😊
ramp-signal-4 = 😃
ramp-signal-5 = 😈

; Only applies if <animation-packetloss> is used
animation-packetloss-0 = ⚠
animation-packetloss-0-foreground = #ffa64c
animation-packetloss-1 = 📶
animation-packetloss-1-foreground = #000000
; Framerate in milliseconds
animation-packetloss-framerate = 500
```
