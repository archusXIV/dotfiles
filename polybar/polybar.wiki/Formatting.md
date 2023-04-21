
Make sure you read the [Configuration wiki page](https://github.com/polybar/polybar/wiki/Configuration).

## Formats

Most modules define a `format-NAME` field, which lets you configure the output format of the module. Formats contain [labels](#label), [progress bars](#progressbar), [ramps](#ramp), etc and labels in turn contain [tokens](#tokens). Formats are what ultimately decide the output of a module.

For example, the mpd module defines the following formats that will be used depending on connection state

```dosini
[module/mpd]
format-online = ...
format-offline = ...
```

All formats can be configured using the following parameters:
```dosini
format-NAME = ...

; The prefix and suffix properties contains all
; properties that are available for any `<label>`.
format-NAME-prefix = ...
format-NAME-prefix-foreground = #f00
format-NAME-suffix = ...
format-NAME-suffix-background = #0f0

; By only specifying alpha value, it will be
; applied to the bar's default foreground/background color
format-NAME-foreground = #aa[rrggbb]
format-NAME-background = #aa[rrggbb]
format-NAME-underline  = #aa[rrggbb]
format-NAME-overline   = #aa[rrggbb]

; Number of spaces, points or pixels
format-NAME-padding = N[pt|px]
format-NAME-margin  = N[pt|px]
format-NAME-spacing = N[pt|px]

; Use Nth font for this format (1-indexed)
format-NAME-font = N

; Displace the format block horizontally by +/-N pixels or points
format-NAME-offset = N{pt,px}
```
_TODO: Improve section_

## Tokens

Tokens can be used in many labels to display dynamic values set by the module. For example in the [`internal/date`](https://github.com/polybar/polybar/wiki/Module:-date) module, `%time%` will be replaced with the formatted time string.

```dosini
label = %token%

; Set value min width
; If the min-width begins with a `0`, the string will be zero-padded
label = %token:3%

; Set value max width
; NOTE: the length of the token includes suffixes appended internally (KB/s, %, etc.)
label = %token:0:10%

; Specify suffix to be used if truncated to max width
label = %token:0:10:...%
label = %token:0:10:---%
```


## Content types

There are different ways to display a value or values from a module, these are Content Types. 

### Label

A label is simply text. You may include a token which represents a value. 

NAME represents the name of the label.

_TODO: Improve section_
```dosini
label-NAME = foobar
;label-NAME-foreground = #aarrggbb
;label-NAME-background = #aarrggbb
;label-NAME-overline = #aarrggbb
;label-NAME-underline = #aarrggbb
;label-NAME-font = N

; Add N spaces, points, pixels before and after the label
; Spacing added this way is not affected by the label colors
; Default: 0
label-NAME-padding = N[pt|px]

; Add N spaces, points, pixels before and after the label text
; Spacing added this way is affected by the label colors
; Default: 0
label-NAME-margin = N[pt|px]

; Truncate text if it exceeds given limit. 
; Default: 0
label-NAME-maxlen = 30

; Pad with spaces if the text doesn't have at least minlen characters
; Default: 0
label-NAME-minlen = 10
; Alignment when the text is shorter than minlen
; Possible Values: left, center, right
; Default: left
label-NAME-alignment = center

; Optionally append ... to the truncated string.
; Default: true
label-NAME-ellipsis = false
```

### Progressbar
_TODO: Improve section_
```dosini
bar-NAME-format = %fill%%indicator%%empty%
bar-NAME-width = 10

bar-NAME-gradient = true
bar-NAME-foreground-0 = #00ff00
bar-NAME-foreground-1 = #ff9900
bar-NAME-foreground-2 = #ff0000

; The fill, indicator and empty icon can be configured like any <label>
bar-NAME-fill = x
bar-NAME-indicator = x
bar-NAME-empty = x
```

### Ramp

Ramps are used to display different things depending on some value reported by the module (e.g. volume):

```dosini
ramp-NAME-0 = A
ramp-NAME-1 = B
ramp-NAME-2 = C
```

The first and last element are responsible for the edges of the range of values.
For example if a module provides a percentage, `ramp-NAME-0 = A` will be displayed if that percentage is 0 (or lower if that is supported)
and `ramp-NAME-2 = C` is used for values >= 100.
The inside of the range is evenly distributed between the remaining ramp elements.

Ramp entries are based on labels which means that you can define all properties that are available for a `<label>`, for example:
```dosini
ramp-NAME-0-foreground = #00f
ramp-NAME-1-background = #f90
```

To avoid repetition it's possible to define default values for each entry on the `<ramp>` itself.
The following would set the background/foreground color for all entries with a custom foreground color for `ramp-NAME-0`.
```dosini
ramp-NAME-background = #fff
ramp-NAME-foreground = #000
ramp-NAME-0 = A
ramp-NAME-0-foreground = #f00
ramp-NAME-1 = B
ramp-NAME-2 = C
```

#### Ramp Weights

*New in version 3.6.0*

Each ramp element also has a weight associated with it (defaults to `1`) which
defines how much of the overall range, the element is assigned to:

```dosini
ramp-NAME-0 = A
ramp-NAME-1 = B
ramp-NAME-1-weight = 9
ramp-NAME-2 = B
ramp-NAME-3 = D
```

Here, the first and last element are again responsible for the edges of the
range. The second element has weight `9` and the third has the default weight
`1`. This means for the first 90% of the ramp range the second element is used
and for the remaining 10%, the third element is used.

### Animation
_TODO: Improve section_

## Sizes & Spacing

*New in version 3.6.0*

In many parts of the config, you can specify some kind of size (width, height,
border) or spacing (margin, padding). These are similar but all differ
slightly.
We differentiate between three types: [spacing](#spacing), [extents](#extent),
and ["percentage with offset"](#percentage-with-offset).

### Spacing

Spacing can be specified as either a number of spaces (no unit), pixels (`px`) or points (`pt`).
For example:

```dosini
; 10 spaces
label-padding = 10
; 20 pixels
label-padding = 20px
; 15 points
label-padding = 15pt
```

Spaces are just added as whitespace characters, the size depends on the active font.
One point is 1/72th of an inch and is translated to a number of pixels according to the specified DPI.

### Extent

Extent values are almost like [spacing](#spacing) but don't support spaces, only pixels (no unit or `px`) and points (`pt`).
These are mainly used to described the size of something (and thus can't support spaces)

### Percentage with Offset

A percentage with offset specifies the size of something using a relative percentage together with an [extent](#extent) value that is added to it.
For example:

```dosini
[bar/...]
...
width = 90%:-10pt
```

This specifies a bar width of 90% minus 10 points. What exactly the percentage is relative to depends on the setting. For the bar width, it is relative to the width of the monitor.

Both the percentage value and the [extent](#extent) value can also be specified on their own:

```dosini
width = 100%
height = 12pt
```

## Format tags

Polybar has built-in support for basic [lemonbar tags](https://github.com/LemonBoy/bar#formatting).

**NOTE**: The `%{U}` tag has been replaced by `%{u#hex}` and `%{o#hex}` to allow changing under-/overline color independently.

A script that is called from a `custom/script` module can wrap its output (or parts of it) in these format tags to 
change how polybar displays the text in between them.

### Format tags inside polybar config
Of course you can use the format tags inside other modules also, but since most `format-` field have their own 
`foreground`, `background`, etc suffixes, this often is not necessary. One use case is to style only parts of a label, for
example if in the volume module you wanted to only display the percentage in a certain color but not the percent sign, 
you could use the foreground tag like this:
```dosini
label-volume = %{F#f00}%percentage%%{F-}%
```
**Pitfalls:** As described in [`#615`](https://github.com/polybar/polybar/issues/615) using polybar variables inside 
format tags is not possible. So something like this **won't** work:
```dosini
label = "Some text %{F${colors.foreground-alt}}Colored%{F-}"
```
If you want this behaviour, you'll need to define the whole label string, with the color codes, in an environment
variable before you start the bar and then reference that variable inside the config like this:
```bash
export BAR_MODULE_LABEL="Some text %{F$COLOR_FG_ALT}Colored%{F-}"
```
This means, you will also have to define the colors as environment variables.

And inside the polybar config:
```dosini
...
label = ${env:BAR_MODULE_LABEL}
...
```

### Foreground color `%{F}`
```
%{F#f00} red text %{F-} default text
```

### Background color `%{B}`
```
%{B#f00}%{F#000} black text on red background %{B- F-}
```

### Reverse back-/foreground colors `%{R}`
```
black bg, white fg %{R} white bg, black fg
```

### Underline color `%{u}`
```
%{u#ff9900}%{+u} orange underline %{u#0000ff} blue underline %{u-} default underline color %{-u} underline disabled
```

### Overline color `%{o}`
```
%{o#ff9900}%{+o} orange overline %{o#0000ff} blue overline %{o-} default overline color %{-o} overline disabled
```

### Font `%{T}`
```
%{T3} Uses font-2 %{T-} use first (default) font
```

Notice how the font tag uses a 1-based index, same as the `-font` property. See also [[Fonts]].

### Offset `%{O}`

Inserts a gap of the specified size (can also be negative).

```
%{O10} pushed 10 pixels to the right %{O-5pt} 5 points to the left
```

The value specified can be any [extent](#extent) value.

### Action `%{A}`
Actions handlers are defined using the following syntax: `%{A<button-index><colon><command><colon>}<inner-text>%{A}`
```
%{A1:command:} clickable text %{A}
```
**Note:** If `command` contains any colons (`:`), you have to escape them with a backslash like this: `\:`. Otherwise the colon acts as the command delimiter and polybar would only parse the command until the colon.

The following values for `<button-index>` are allowed:
* `1`: left click
* `2`: middle click
* `3`: right click
* `4`: scroll up
* `5`: scroll down
* `6`: double left click
* `7`: double middle click
* `8`: double right click

**Note:** Double click actions may not work reliably.

#### Nested Actions #### 

As with any formatting tag you can also have **nested action**. For example:

```
%{A1:...:}%{A2:...:}Some clickable text%{A} only left click%{A}
```
The text inside both tags responds to both left and middle clicks.

If you nest actions for the same button, the innermost action tag will be chosen when clicked:

```
%{A1:firefox:}%{A1:chromium:}This opens chromium%{A} and this one firefox%{A}
```


