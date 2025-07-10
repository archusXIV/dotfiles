This page lists some of the issues one can encounter when using polybar. Either quirks in polybar's behaviour or actual bugs we haven't been able to fix yet.

# Contents
- [Running Polybar](#running-polybar)
  * [Label `maxlen` truncates formatting tags](#label-maxlen-truncates-formatting-tags)
  * [`Failed to get root pixmap, default to black (is there a wallpaper?)`](#failed-to-get-root-pixmap-default-to-black-is-there-a-wallpaper)
  * [`Cannot find root pixmap, try a different tool to set the desktop background`](#cannot-find-root-pixmap-try-a-different-tool-to-set-the-desktop-background)
  * [Huge Emojis](#huge-emojis)
  * [Error While Loading Shared Libraries: libjsoncpp](#error-while-loading-shared-libraries-libjsoncpp)
  * [Setting Module Backgrounds when using Gradients](#setting-module-backgrounds-when-using-gradients)
  * [`override-redirect` in i3](#override-redirect-in-i3)
  * [Mouse Interactions not Working in AwesomeWM](#mouse-interactions-not-working-in-awesomewm)
  * [`xkeyboard` module starts with 'us' layout at startup](#xkeyboard-module-starts-with-us-layout-at-startup)
- [Compiling Polybar](#compiling-polybar)
  * [Building with Anaconda installed](#building-with-anaconda-installed)



# Running Polybar

## Label `maxlen` truncates formatting tags

**Problem:** Labels with a `maxlen` property will count formatting tokens when determining where to truncate the label. For example:

```dosini
label = %{F#ff0000}some text
label-maxlen = 5
```

Will result in just `%{F#f` being shown. This can also lead to `X unclosed
action blocks` errors when `%{A...}` action blocks are used.

The same problem also occurs if the `%output%` token in the `custom/script` or `custom/ipc` module is given a maximum length and the contents of the token contains formatting tags.

**Workaround:** Try not to put formatting tags in labels with `maxlen`. Instead, try any/multiple of the following:

- Use the label's built-in [formatting](./Formatting) properties if possible
- Use the token's built-in max-width property (`%token:0:<max width>%`) to truncate specific values instead of `maxlen`.
- Put the formatting tags in the `format` settings if possible (e.g. `format = %{A1:...}<label>%{A1}` instead of `label = %{A1:...}...${A1}`)
- If the formatting tags only appear at the beginning of the label, you can extend the `maxlen` property by the known number of characters in the formatting tags.

This issue is tracked in [`#531`](https://github.com/polybar/polybar/issues/531).

## `Failed to get root pixmap, default to black (is there a wallpaper?)`
Polybar prints this warning when there is no wallpaper set and `pseudo-transparency = true` is set. Polybar will still 
run but assume the wallpaper is all black. 

**Fix:** We suggest setting a wallpaper with `feh` or `nitrogen`.

## `Cannot find root pixmap, try a different tool to set the desktop background`
When you use a tool like ImageMagick (`display -window root`) to set the wallpaper and have `pseudo-transparency = true`
set, polybar fails to find the wallpaper to use for making the bar transparent. It will assume the background is black 
when rendering transparent colors.

**Fix:** As [above](#failed-to-get-root-pixmap-default-to-black-is-there-a-wallpaper), we suggest to set the wallpaper 
with a tool like `feh` or `nitrogen`


## Huge Emojis
**Problem:** When using the Noto Emoji font, Emojis appear extremely big on the bar. Setting the `size` property doesn't help.

**Fix:** Add the `scale` property to the font definition in your config. For example `font-7 = NotoEmoji:scale=10`. The larger the number the smaller the Emojis.

This issue was discovered in [`#905`](https://github.com/polybar/polybar/issues/905).

## Error While Loading Shared Libraries: libjsoncpp
**Problem:** When you update the `jsoncpp` package, you might get the following error, when trying to run polybar:
```
polybar: error while loading shared libraries: libjsoncpp.so.XX: cannot open shared object file: No such file or directory
```
This issue occurs because `jsoncpp` changes the name of their `.so` file every release and there really isn't anything we can do about that.

**Fix:** You have to recompile polybar, so that it links to the new `.so` file. If you use precompiled binaries from a repository, you either have to compile polybar yourself or contact the packager so that they can recompile polybar and publish a package with proper linkage. 

**Note:** If you are using a program to automatically compile polybar for your
(for example an AUR helper), just reinstalling may not solve this problem, the
program may just reuse already compiled binaries. You need to make sure that
polybar is *recompiled*. How to do that depends on the program, but most offer a
way to force a rebuild or a way to clear the cache for certain packages.

## Setting Module Backgrounds when using Gradients
**Problem:** When you use a gradient as your polybar background, explicitly setting any module's background color to whatever you have set as `background-0`, either through the `-background` setting or the `%{B}` formatting tag, will not change the background color at all.

**Workaround:** If you want to explicitly set a module's (or parts of its) background to `background-0`, use a color that is almost the same. E.g. if `background-0` is `#FFFF00` use `#FFFF01`. 

This behaviour was introduced in [`#831`](https://github.com/polybar/polybar/pull/831), to resolve the issue described in [`#759`](https://github.com/polybar/polybar/issues/759). There is no way to resolve this without some major code changes to the renderer.

## `override-redirect` in i3
**Problem:** i3 and polybar sometimes interact quite weirdly and often `override-redirect = true` is needed to resolve it. This however makes i3 not reserve space for the polybar window, making other windows overlap polybar. There doesn't seem to be that much that we can do about this from polybar's side, because as soon as we need to use `override-redirect = true`, we can't tell i3 to reserve space for the polybar window.

**Workaround:** The workaround that some people use, is to create a full-width fully transparent dummy bar on the same monitor and in the same position (with `override-redirect = false`), so that i3 reserves space for this dummy bar, effectively also reserving space for our actual bar. The real bar may need to have `wm-restack = i3` set for it to not overlap with fullscreen windows. **Note:** This requires that you have a composition manager running because the dummy bar may overlap the real bar.

If you are using i3-gaps (>= 4.17), you can set `gaps top X` or `gaps bottom X` in your i3 config to reserve space for the bar where `X` is the number of pixels you want to reserve. **Note:** On multi-monitor setups this will be applied to all monitors.

## Mouse Interactions not Working in AwesomeWM

**Problem:** For some reason AwesomeWM seems to prevent polybar from receiving
mouse events on the bar once polybar is the focused window. 

**Solution:** The only fix for this seems to be to set `override-redirect =
true` in your bar section. This tells AwesomeWM to not manage the polybar
window.

## `xkeyboard` module starts with 'us' layout at startup

When polybar is started as part of a WM's startup routine, it is possible that
the xkeyboard module mistakenly displays the layout as 'us' and then corrects
itself once any key is pressed.

This is a known issue in the xcb library that we use to access the X server:
https://gitlab.freedesktop.org/xorg/xserver/-/issues/257

# Compiling Polybar

## Building with Anaconda installed
**Problem:** On systems using Anaconda compiling polybar will likely fail with one of these error messages:
* `Missing required python module: xcbgen`
* `ERROR: could not calc required_start_align of Struct "xcb.Setup"`
* `Cairo was not compiled with support for the xcb backend`

The general issue is that the libraries and programs provided by Anaconda cannot be used to build polybar in many cases.

**Fix:** The easiest fix is to uninstall Anaconda if you don't need it.

If you can't/don't want to uninstall Anaconda, we need to force polybar to not use any resources provided by Anaconda.
This can be done by temporarily removing any paths that point to anaconda from both the `$PATH` and `$PKG_CONFIG_PATH` environment variables in the terminal before building polybar.

People have reported that `conda deactivate` does that for you for the currently open terminal. If that doesn't work, try doing it manually:

For example if your `PATH` variable contains:

```
/home/<user>/anaconda2/bin:/home/<user>/bin:...:/usr/bin
```

Remove `/home/<user>/anaconda2/bin` and reexport the variable:

```
export PATH=/home/<user>/bin:...:/usr/bin
```

Do the same thing for `PKG_CONFIG_PATH` (though this variable is often already empty). Now you should be able to build 
polybar with either the `build.sh` script or `cmake` and `make`. Make sure that you do a clean build (redownload all 
polybar sources).

This was reported in [`#502`](https://github.com/polybar/polybar/issues/502), 
[`#733`](https://github.com/polybar/polybar/issues/733), [`#659`](https://github.com/polybar/polybar/issues/659), 
[`#1629`](https://github.com/polybar/polybar/issues/1629)

