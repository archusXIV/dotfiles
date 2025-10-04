Make sure you read the [Configuration wiki page](/polybar/polybar/wiki/Configuration) on how to define the list of fonts to use.

> [!NOTE]
> The example configurations on the wiki occasionally use font icons. For
> maximum compatibility, we tried to make sure that all icons are either emojis
> or covered by [Unifont](https://unifoundry.com/unifont/index.html).
>
> For emojis, we recommend the [Noto Color Emoji](https://github.com/googlefonts/noto-emoji) font.
> For Unifont, you need the base `Unifont` font as well as the `Unifont Upper` and `Unifont CSUR` variants.

## Fonts
If you don't explicitly set the font-index for a tag, the bar will iterate the font list and pick the first one that is able to draw the character. [Read more on the wiki page about Formatting](https://github.com/polybar/polybar/wiki/Formatting) and about what tags allow you to define a specific font index.

**NOTE**: The `-font` property is a 1-based index of available fonts (which means that `*-font = 1` will use `font-0`).

```dosini
[bar/example]
; font-N = <fontconfig pattern>;<vertical offset>
font-0 = "Tamsyn:pixelsize=12;0"
font-1 = "Roboto:size=11:weight=bold;2"
font-2 = "Noto Sans:size=11;1"

[module/example]
label-active = %token%

; This tells the bar to use Roboto when rendering the label
label-active-font = 2

; Using raw formatting tags, you can mix fonts.
; %{T3} tells the bar to use Noto Sans and %{T-} resets it to default.
label-inactive = %{T3}Inactive%{T-} %time%
```

When using icon fonts, you normally won't have to specify a font index because the other fonts probably doesn't contain the icon glyph. But in case the icon doesn't show up or the result looks odd, you should manually specify the font to be used.


## Debugging Font Issues
If you have any issues with characters/icons not displaying correctly or **`Dropping unmatched character`** warnings, follow these steps before opening an issue, you will get referred back to them if you don't.

Follow these steps very carefully and in the order they are given and do not skip any!


1. **Confirm all fonts are loaded properly:**
To do that, follow the instructions in the [Finding Font Names](#finding-font-names) section.
2. **Check that all the icons you use are available in the fonts used:**  
Use `gucharmap` and enable `View > Show only glyphs from this font` (**this is
important**), then search (`Ctrl-F`) for the dropped characters (copy them from
the terminal output), then switch to each font in your config, using the
dropdown in the top left. 
If the desired icon never shows up, none of the fonts in your polybar config support that icon.
To find a font that provides that icon, we suggest you use the [perl
script](#find-fonts-for-glyphs) at the bottom of this page.  
Another way is to disable `Show only glyphs from this font` in `gucharmap`, the icon should now show up again, if it doesn't you don't have any font on your system that supports that icon. If it does show up, you can hold right click and it will show you the font it's from in the tooltip.
3. **Check font order:** If you have no more **`Dropping unmatched character`** warnings but the wrong icons are displayed, you may have a font conflict where two fonts provide a font icon in the same position (codepoint). Make sure that none of the fonts in the font list, before the font that the icon is from, have a character at the same position.
You can do that by changing the order in which you define the fonts, although this can lead to conflicts in the other direction. The safest way is to use the `-font` property or the `%{T}` tag to specify which font to use, as described at the beginning of this page.

Also see [known issues](https://github.com/polybar/polybar/wiki/Known-Issues) for more help.

## Finding Font Names
Polybar uses fontconfig to match font descriptions to a specific font. 
To get the name for a font, use `fc-list` to list all fonts and their names installed on your system.
For example one line in the output could look like this:

```
/usr/share/fonts/noto/NotoSansMono-Regular.ttf: Noto Sans Mono:style=Regular
```

If we wanted to add that font to polybar we would need to set:

```dosini
font-0 = Noto Sans Mono:style=Regular
```

You need to make sure that you copy the **exact** name (everything after the file path) otherwise polybar may not be able to match it. 

**Note:** For some fonts you may need to provide multiple font names, for example the output of `fc-list | grep -i awesome` gives three FontAwesome5 fonts:

```
/usr/share/fonts/TTF/fa-brands-400.ttf: Font Awesome 5 Brands,Font Awesome 5 Brands Regular:style=Regular
/usr/share/fonts/TTF/fa-solid-900.ttf: Font Awesome 5 Free,Font Awesome 5 Free Solid:style=Solid
/usr/share/fonts/TTF/fa-regular-400.ttf: Font Awesome 5 Free,Font Awesome 5 Free Regular:style=Regular
```

You will likely need all of them.

To make sure that the correct font gets loaded, check the polybar output in the terminal: For all the lines that start with `notice: Loaded font` check that the font name in brackets matches the font name before the brackets, if they don't match you either don't have the given font installed or there is something wrong with the name you used.

You can also test your pattern using `fc-match`, for example:

```sh
$ fc-match myfont:weight=bold:size=14
```

If `fc-match` doesn't properly match the name, then polybar won't either, so it's often more convenient to check your font names with `fc-match` first.

**Note:** Polybar will not always print an error if a font is not found, it may just fall back to the default font (This is due to the library doing the font matching).

If one of the fonts doesn't match, then either that fonts has a different name on your system or it isn't installed. See the beginning of this section for finding out how you can figure out font names on your system.

For debug purposes, you can make fontconfig output the font results when launching the bar, using: 

```sh
$ FC_DEBUG=1 polybar mybar ...
```

### Anti-aliasing
You might get better results for some fonts if you turn off antialiasing:

```dosini
font-0 = "myfont:antialias=false"
```

### Bitmap Fonts

Some icon fonts are bitmap fonts, which may be disabled in your distro (e.g.
Debian-based distros).

On Debian-based systems, bitmap fonts can be enabled by running

```sh
sudo dpkg-reconfigure fontconfig-config
```

And enabling bitmap fonts in the dialog.

If that doesn't work or on other distros by deleting the file
`/etc/fonts/conf.d/70-no-bitmaps.conf` and running `fc-cache` afterwards to
reload the font cache.

### Icon Fonts
Icons can be provided in the form of text characters. Popular icon fonts include:
- [FontAwesome](https://fontawesome.com/) - SIL OFL 1.1
- [Material icons](https://material.io/icons/) - Apache 2.0
- [IcoMoon](https://icomoon.io/app/#/select/library) - Custom/Mixed Licenses
- [Nerd Patched Fonts](https://github.com/ryanoasis/nerd-fonts) - Mixed Licenses

Some issues around rendering issues with Nerd Fonts are described
[here](https://polybar.readthedocs.io/user/fonts/nerd-fonts.html).

Most icon fonts make use of the Private Use Area unicode block and can conflict. 
After defining a font as explained above, [formatting tags](https://github.com/polybar/polybar/wiki/Formatting#format-tags) can be used. 
Order of font definitions can also affect precedence.

### [GNOME Character Map](https://en.wikipedia.org/wiki/GNOME_Character_Map) 
`gucharmap` is a convenient utility for browsing selected fonts. Filter `View > By Unicode Block + Show only glyphs from this font` and navigate to Private Use Area.
If you find an icon in `gucharmap` but don't know which font it's from, you can hover over it and right click to display the font.

### Find Fonts for Glyphs
If you have glyphs in your config but don't know which fonts provide that icon, [**@fbreitwieser**](https://github.com/fbreitwieser) has written a little perl script that searches all installed fonts for a given glyph:
```perl
#test-fonts.pl
use strict;
use warnings;
use Font::FreeType;
my ($char) = @ARGV;
foreach my $font_def (`fc-list`) {
    my ($file, $name) = split(/: /, $font_def);
    my $face = Font::FreeType->new->face($file);
    my $glyph = $face->glyph_from_char($char);
    if ($glyph) {
        print $font_def;
    }
}
```

Usage: `perl test-fonts.pl "😀"`

```
/usr/share/fonts/TTF/DejaVuSansCondensed.ttf: DejaVu Sans,DejaVu Sans Condensed:style=Condensed,Book
/usr/share/fonts/TTF/DejaVuSans-BoldOblique.ttf: DejaVu Sans:style=Bold Oblique
/usr/share/fonts/TTF/Symbola.ttf: Symbola:style=Regular
/usr/share/fonts/TTF/Unifont_Upper.ttf: Unifont Upper:style=Medium
/usr/share/fonts/TTF/DejaVuSansCondensed-Oblique.ttf: DejaVu Sans,DejaVu Sans Condensed:style=Condensed Oblique,Oblique
/usr/share/fonts/TTF/DejaVuSansCondensed-BoldOblique.ttf: DejaVu Sans,DejaVu Sans Condensed:style=Condensed Bold Oblique,Bold Oblique
/usr/share/fonts/TTF/DejaVuSans-Oblique.ttf: DejaVu Sans:style=Oblique
/usr/share/fonts/TTF/DejaVuSansCondensed-Bold.ttf: DejaVu Sans,DejaVu Sans Condensed:style=Condensed Bold,Bold
/usr/share/fonts/noto/NotoColorEmoji.ttf: Noto Color Emoji:style=Regular
/usr/share/fonts/TTF/DejaVuSans.ttf: DejaVu Sans:style=Book
/usr/share/fonts/TTF/DejaVuSans-Bold.ttf: DejaVu Sans:style=Bold
```
Note: maybe you need to install "Font::FreeType" module for the Script to work:
```
$ perl -MCPAN -e 'install Font::FreeType'
```
