This module shows volume and mute state for ALSA mixers. 
Most of the module functionality should work as long as you are using an alsa backend.

**Do not use this module if you are using pulseaudio ❗️**

If you use `pulseaudio` use the
[`internal/pulseaudio`](https://github.com/polybar/polybar/wiki/Module:-pulseaudio)
module instead, even if it uses alsa as the backend.
There are a number of issues when alsa is used to control the volume in a
pulseaudio server.

**NOTE**: This module requires the project to be built with ALSA support.

### Basic settings
```ini
[module/alsa]
type = internal/alsa

; Soundcard to be used
; Usually in the format hw:# where # is the card number
; You can find the different card numbers in `/proc/asound/cards`
master-soundcard = default
speaker-soundcard = default
headphone-soundcard = default

; Name of the master, speaker and headphone mixers
; Use the following command to list available mixer controls:
; $ amixer scontrols | sed -nr "s/.*'([[:alnum:]]+)'.*/\1/p"
; If master, speaker or headphone-soundcard isn't the default, 
; use `amixer -c # scontrols` instead where # is the number 
; of the master, speaker or headphone soundcard respectively
;
; Default: Master
master-mixer = Master

; Optionally define speaker and headphone mixers
; Default: none
speaker-mixer = Speaker
; Default: none
headphone-mixer = Headphone

; NOTE: This is required if headphone_mixer is defined
; Use the following command to list available device controls
; $ amixer controls | sed -r "/CARD/\!d; s/.*=([0-9]+).*name='([^']+)'.*/printf '%3.0f: %s\n' '\1' '\2'/e" | sort
; You may also need to use `amixer -c # controls` as above for the mixer names
; Default: none
headphone-id = 9

; Use volume mapping (similar to amixer -M and alsamixer), where the increase in volume is linear to the ear
; Default: false
mapped = true

; Interval for volume increase/decrease (in percent points)
; Default: 5
interval = 5
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
;label-volume = %percentage%%

; Available tokens:
;   %percentage% (default)
label-muted = 🔇 muted
label-muted-foreground = #66

; Only applies if <ramp-volume> is used
ramp-volume-0 = 🔈
ramp-volume-1 = 🔉
ramp-volume-2 = 🔊

; If defined, it will replace <ramp-volume> when
; headphones are plugged in to `headphone_control_numid`
; If undefined, <ramp-volume> will be used for both
; Only applies if <ramp-volume> is used
ramp-headphones-0 = 
ramp-headphones-1 = 

; Right and Middle click
; New in version 3.6.0
; click-right =
; click-middle = 
```
