This module lets you create text menus. It is possible to control the menu using [Inter-process messaging](https://github.com/polybar/polybar/wiki/Inter-process-messaging).

**Note:** With version 3.5.0, the way to open and close the menu levels has
changed.
In particular, if you use `menu-open-*` or `menu-close` in your menu module, you
should update the module to use the new action names.
A guide for this can be found
[here](https://polybar.readthedocs.io/en/stable/user/actions.html#deprecated-action-names).

### Basic settings

The menu module uses
[actions](https://polybar.readthedocs.io/en/stable/user/actions.html) for
opening and closing menu levels. 
For example to open level N, the action is `open.N`, to close the menu, the
action is called `close`. Please read the link above to learn how to construct
the full action string.

```ini
[module/menu-apps]
type = custom/menu

; If true, <label-toggle> will be to the left of the menu items (default).
; If false, it will be on the right of all the items.
expand-right = true

; "menu-LEVEL-N" has the same properties as "label-NAME" with
; the additional "exec" property
;
; Commands will be executed using "/bin/sh -c $COMMAND"

menu-0-0 = Browsers
menu-0-0-exec = #menu-apps.open.1
menu-0-1 = Multimedia
menu-0-1-exec = #menu-apps.open.2

menu-1-0 = Firefox
menu-1-0-exec = firefox
menu-1-1 = Chromium
menu-1-1-exec = chromium

menu-2-0 = Gimp
menu-2-0-exec = gimp
menu-2-1 = Scrot
menu-2-1-exec = scrot
```

### Additional formatting
```ini
; Available tags:
;   <label-toggle> (default) - gets replaced with <label-(open|close)>
;   <menu> (default)
; If expand-right is true, the default will be "<label-toggle><menu>" and the
; other way around otherwise.
; Note that if you use <label-toggle> you must also include
; the definition for <label-open>
; format = <label-toggle><menu>

label-open = Apps
label-close = x

; Optional item separator
; Default: none
label-separator = |
```
