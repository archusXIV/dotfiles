The parameters on **this page** are using the default values unless stated otherwise.
If the key is undefined (commented out) or its value is empty, it means there is no default value for the given parameter.

## Configuration Syntax
The configuration uses the [INI file
format](https://en.wikipedia.org/wiki/INI_file), the full specification can be
found [here](https://polybar.readthedocs.io/man/polybar.5.html).

```dosini
[section/name]
str = My string
bool = true
bool = on
int = 10
float = 10.0

; Quote string values if you want to keep surrounding spaces
str = "   My string"

; Lists are defined using a 0-based index
mylist-0 = value
mylist-1 = value
mylist-2 = value
; Lists cannot have gaps. To define mylist-4 
; you will also have to define mylist-3
```

## Referencing values
```dosini
; You can reference a value in another section using:
key = ${section.key}

; Values in the same section can be referenced using:
key = ${self.key}

; Values for a defined bar can be referenced using:
key = ${bar/top.foreground}

; Values for the current bar can be referenced using:
key = ${root.foreground}

; Environment variables can be referenced using:
key = ${env:VAR:fallback value}

; Values in the X resources db can be referenced using:
; NOTE: Requires `+xrm` (compiled with `xcb-util-xrm` dependency)
; Example: 
; Polybar config:
;     background = ${xrdb:color2:#00ff00}
; .Xresources:
;     *color2: #8C9440
key = ${xrdb:KEY:fallback value}

; File contents can be referenced using:
key = ${file:/absolute/file/path:fallback value}
```

**Note:** References can only be used on their own. That means something like 
`key = text ${section.key} text` will not work (the reference will not be resolved).

## Inheritance
Values can be inherited from another section by defining the parameter `inherit = section/base`.
All undefined keys will be cloned.
```dosini
[section/base]
foo = 1
bar = 0.15
baz = true

[section/child]
inherit = section/base
baz = false

; Result
[section/child]
foo = 1
bar = 0.15
baz = false
```

Multiple sections can be inherited by adding multiple space separated section
names to the inherit key: `inherit = section1 section2`.

## File inclusion
It is possible to include a file or all files in a directory with pre-defined
key-value pairs using:

```dosini
include-file = /absolute/path/to/file
include-directory = /absolute/path/to/directory
; Relative paths are new in version 3.6.0
include-file = relative/path/to/file
include-directory = relative/path/to/directory
```

This is equivalent to replacing the `include-file` directive with the contents
of the file.

The `include-directory` directive will include all files in the given directory
(non-recursively) the same way as multiple `include-file` directives. Files are
included in alphabetical order.

**Note:** The files included that way can also contain further `include-file`
and `include-directory` keys. Make sure that you do not create a cycle where a
file includes itself directly or indirectly.

Multiple include directives can be defined inside a section because they are not
proper config keys.

When specifying a relative path, the path is taken relative to the file where
the include directive is defined. 

## Custom variables
```dosini
; You can create your own local variables, for example:
[colors]
black = #000
white = #fff
blue = #00f
green = #0f0

[modules/tmp]
format-background = ${colors.black}
format-foreground = ${colors.white}
```

### Using the same module for multiple bars
If you are using the same module for more than one bar, there's a neat way to make bar specific changes to the module configuration. Define some custom parameters, for both bars, and then reference them from the module. For example:
```dosini
[bar/top]
myscript-background = #f00
myscript-command = whoami

[bar/bottom]
myscript-background = #f00
myscript-command = date +%s

[module/myscript]
format-background = ${root.myscript-background}
exec = ${root.myscript-command}
```

## Bar settings

Each bar you want to display needs a so called "bar section".
The bar section is defined as a config section that begins with `bar/` and is
followed by the name of the bar.

Configuring the tray through the bar section is deprecated in favor of the new
[tray module](https://polybar.readthedocs.io/user/modules/tray.html).

***Note*** For configuring multiple monitors automatically see https://github.com/polybar/polybar/issues/763

```dosini
; Defines a bar called 'mybar'
[bar/mybar]
; Use either of the following command to list available outputs:
; $ polybar -M | cut -d ':' -f 1
; $ xrandr -q | grep " connected" | cut -d ' ' -f1
; If no monitor is given, the primary monitor is used if it exists
monitor =

; Use the specified monitor as a fallback if the main one is not found.
monitor-fallback =

; Require the monitor to be in connected state
monitor-strict = false

; Use fuzzy matching for monitors (only ignores dashes -)
; Useful when monitors are named differently with different drivers.
monitor-exact = true

; Tell the Window Manager not to configure the window.
; Use this to detach the bar if your WM is locking its size/position.
; Note: With this most WMs will no longer reserve space for 
; the bar and it will overlap other windows. You need to configure
; your WM to add a gap where the bar will be placed.
override-redirect = false

; Put the bar at the bottom of the screen
bottom = false

; Prefer fixed center position for the `modules-center` block. 
; The center block will stay in the middle of the bar whenever
; possible. It can still be pushed around if other blocks need
; more space.
; When false, the center block is centered in the space between 
; the left and right block.
fixed-center = true

; Width and height of the bar window.
; Supports any percentage with offset or an extent value.
; For 'width', the percentage is relative to the monitor width and for 'height'
; relative to the monitor height
width =
height =

; Offset the bar window in the x and/or y direction.
; Supports any percentage with offset relative to the monitor width (offset-x)
; or height (offset-y)
offset-x = 0
offset-y = 0

; Background ARGB color (e.g. #f00, #ff992a, #ddff1023)
background = #fff

; Foreground ARGB color (e.g. #f00, #ff992a, #ddff1023)
foreground = #000

; Background gradient (vertical steps)
;   background-[0-9]+ = #aarrggbb
background-0 = 

; Value used for drawing rounded corners
; For this to work you may also need to enable pseudo-transparency or use a
; compositor like picom.
; Individual values can be defined using:
;   radius-{top,bottom}
; or
;   radius-{top,bottom}-{left,right} (New in version 3.6.0)
; Polybar always uses the most specific radius definition for each corner.
radius = 0.0

; Under-/overline pixel size and argb color
; Individual values can be defined using:
;   {overline,underline}-size
;   {overline,underline}-color
line-size = 0
line-color = #f00

; Values applied to all borders
; Individual side values can be defined using:
;   border-{left,top,right,bottom}-size
;   border-{left,top,right,bottom}-color
; The top and bottom borders are added to the bar height, so the effective
; window height is:
;   height + border-top-size + border-bottom-size
; Meanwhile the effective window width is defined entirely by the width key and
; the border is placed within this area. So you effectively only have the
; following horizontal space on the bar:
;   width - border-right-size - border-left-size
; border-size supports any percentage with offset.
; For border-{left,right}-size, the percentage is relative to the monitor width
; and for border-{top,bottom}-size, it is relative to the monitor height.
border-size =
border-color =

; Padding (number of spaces, pixels, or points) to add at the beginning/end of
; the bar
; Individual side values can be defined using:
;   padding-{left,right}
padding = 0

; Margin (number of spaces, pixels, or points) to add before/after each module
; Individual side values can be defined using:
;   module-margin-{left,right}
module-margin = 0

; Fonts are defined using <font-name>;<vertical-offset>
; Font names are specified using a fontconfig pattern.
;   font-0 = NotoSans-Regular:size=8;2
;   font-1 = MaterialIcons:size=10
;   font-2 = Termsynu:size=8;-1
;   font-3 = FontAwesome:size=10
; See the Fonts wiki page for more details
font-0 =

; Modules are added to one of the available blocks
;   modules-left = cpu ram
;   modules-center = xwindow xbacklight
;   modules-right = ipc clock
modules-left =
modules-center =
modules-right =

; The separator will be inserted between the output of each module
; This has the same properties as a label
separator =

; This value is used to add extra spacing between elements
; @deprecated: This parameter will be removed in an upcoming version
spacing = 0

; Opacity value between 0.0 and 1.0 used on fade in/out
dim-value = 1.0

; Value to be used to set the WM_NAME atom
; If the value is empty or undefined, the atom value
; will be created from the following template: polybar-[BAR]_[MONITOR]
; NOTE: The placeholders are not available for custom values
wm-name =

; Locale used to localize various module data (e.g. date)
; Expects a valid libc locale, for example: sv_SE.UTF-8
locale = 

; @deprecated in favor of new tray module since version 3.7.0
; Position of the system tray window
; If empty or undefined, tray support will be disabled
; NOTE: A center aligned tray will cover center aligned modules
;
; Available positions:
;   left
;   center
;   right
;   none
tray-position =

; @deprecated in favor of new tray module since version 3.7.0
; If true, the bar will not shift its
; contents when the tray changes
tray-detached = false

; @deprecated in favor of new tray module since version 3.7.0
; Tray icon max size
tray-maxsize = 16

; @deprecated Since 3.3.0 the tray always uses pseudo-transparency
; Enable pseudo transparency
; Will automatically be enabled if a fully transparent
; background color is defined using `tray-background`
tray-transparent = false

; @deprecated in favor of new tray module since version 3.7.0
; Background color for the tray container 
; ARGB color (e.g. #f00, #ff992a, #ddff1023)
; By default the tray container will use the bar
; background color.
tray-background = ${root.background}

; @deprecated in favor of new tray module since version 3.7.0
; Foreground color for the tray icons
; This only gives a hint to the tray icon for its color, it will probably only
; work for GTK3 icons (if at all) because it targets a non-standard part of the
; system tray protocol by setting the _NET_SYSTEM_TRAY_COLORS atom on the tray
; window.
; New in version 3.6.0
tray-foreground = ${root.foreground}

; @deprecated in favor of new tray module since version 3.7.0
; Offset the tray in the x and/or y direction
; Supports any percentage with offset
; Percentages are relative to the monitor width or height for detached trays
; and relative to the bar window (without borders) for non-detached tray.
tray-offset-x = 0
tray-offset-y = 0

; @deprecated in favor of new tray module since version 3.7.0
; Pad the sides of each tray icon
tray-padding = 0

; @deprecated in favor of new tray module since version 3.7.0
; Scale factor for tray clients
tray-scale = 1.0

; Restack the bar window and put it above the
; selected window manager's root
;
; Fixes the issue where the bar is being drawn
; on top of fullscreen window's
;
; Currently supported values:
;   generic (Tries the ewmh strategy and falls back
;            to the bottom strategy.
;            This is a best-effort strategy and may change and be tweaked in
;            the future, the individual strategies are available on their own)
;           (New in version 3.6.0)
;           (Changed in version 3.7.0: Tries the ewmh strategy instead of just
;            the bottom strategy)
;   bspwm   (Moves the bar window above all bspwm root windows)
;   bottom  (Moves the bar window above the first window in the window stack.
;            Works in xmonad, may not work on other WMs
;            New in version 3.7.0)
;   ewmh    (Moves the bar above the window specified in _NET_SUPPORTING_WM_CHECK,
;            if it is set
;            New in version 3.7.0)
;   i3 (requires `override-redirect = true`)
; wm-restack =

; Whether polybar defines struts (_NET_WM_STRUT_PARTIAL and _NET_WM_STRUT)
; New in version 3.7.0
enable-struts = true

; Set a DPI values used when rendering text
; This only affects scalable fonts
; Set this to 0 to let polybar calculate the dpi from the screen size.
; dpi = 
dpi-x = 96
dpi-y = 96

; Enable support for inter-process messaging
; See the Messaging wiki page for more details.
enable-ipc = false

; Fallback click handlers that will be called if
; there's no matching module handler found.
click-left = 
click-middle = 
click-right =
scroll-up =
scroll-down =
double-click-left =
double-click-middle =
double-click-right =

; If two clicks are received within this interval (ms), they are recognized as
; a double click.
; New in version 3.6.0
double-click-interval = 400

; Requires polybar to be built with xcursor support (xcb-util-cursor)
; Possible values are:
; - default   : The default pointer as before, can also be an empty string (default)
; - pointer   : Typically in the form of a hand
; - ns-resize : Up and down arrows, can be used to indicate scrolling
cursor-click = 
cursor-scroll = 
```


## Global WM settings

Tells the window manager to add extra space below (with `margin-bottom` for top
bars) or above (with `margin-top` for bottom bars) the bar window.
Whether these settings do anything, heavily depends on your window manager.

```dosini
[global/wm]
; Adjust the _NET_WM_STRUT_PARTIAL top value
;   Used for top aligned bars
; Supports any percentage with offset relative to the monitor height
margin-bottom = 0

; Adjust the _NET_WM_STRUT_PARTIAL bottom value
;   Used for bottom aligned bars
; Supports any percentage with offset relative to the monitor height
margin-top = 0
```

## Application settings
```dosini
[settings]
; @deprecated These settings are ignored since 3.6.0
throttle-output = 5
throttle-output-for = 10

; @deprecated The setting is ignored since 3.5.0
throttle-input-for = 30

; Reload when the screen configuration changes (XCB_RANDR_SCREEN_CHANGE_NOTIFY event)
screenchange-reload = false

; Compositing operators
; @see: https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-operator-t
compositing-background = source
compositing-foreground = over
compositing-overline = over
compositing-underline = over
compositing-border = over

; Define fallback values used by all module formats
format-foreground = 
format-background = 
format-underline =
format-overline =
format-spacing =
format-padding =
format-margin =
format-offset =

; Enables pseudo-transparency for the bar
; If set to true the bar can be transparent without a compositor.
pseudo-transparency = false
```

## Module Settings

A module is defined as a config section that begins with `module/` and is
followed by the name of the module (this can be different from the module type).

For a module to show up on your bar, you need to place it by adding its name to the `modules-left`, `modules-center`, or `modules-right` settings in the bar section.

```dosini
; Defines a module named 'mymodule'
[module/mymodule]
; The type of this module
; The wiki pages for the individual modules show the correct values for each module.
type = ...

; Hide the module by default
; Default: false
; New in version 3.6.0
hidden = true
```
