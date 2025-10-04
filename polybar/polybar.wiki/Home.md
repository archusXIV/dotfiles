## Where to start

For a normal installation, polybar will install the default config to
`/etc/polybar/config.ini`.
This config file should be usable out-of-the-box by simply running in your terminal:

```sh
polybar
```

[![](https://raw.githubusercontent.com/polybar/polybar/master/doc/_static/default.png)](https://raw.githubusercontent.com/polybar/polybar/master/doc/_static/default.png)

**Note:** If you have already created your own config in your home directory,
polybar will load that.

To get started with your own customization, you need to create a configuration
file in `~/.config/polybar/config.ini`.

You can copy the default config from `/etc/polybar/config.ini` or start from
scratch.

The config file requires a [bar
section](https://github.com/polybar/polybar/wiki/Configuration#bar-settings)
for each bar you want to define.
Each module also has its own [module
section](https://github.com/polybar/polybar/wiki/Configuration#module-settings)
and can be added to `modules-left`, `modules-center` or `modules-right` in the
bar section to have it display on that bar.

See the [Configuration wiki
page](https://github.com/polybar/polybar/wiki/Configuration) for more details
on how to configure the bar.

## Running the app
```
Usage: polybar [OPTION]... [BAR]

  -h, --help                   Display this help and exit
  -v, --version                Display build details and exit
  -l, --log=LEVEL              Set the logging verbosity (default: notice)
                               LEVEL is one of: error, warning, notice, info, trace
  -q, --quiet                  Be quiet (will override -l)
  -c, --config=FILE            Path to the configuration file
  -r, --reload                 Reload when the configuration has been modified
  -d, --dump=PARAM             Print value of PARAM in bar section and exit
  -m, --list-monitors          Print list of available monitors and exit (Removes cloned monitors)
  -M, --list-all-monitors      Print list of all available monitors (Including cloned monitors) and exit
  -w, --print-wmname           Print the generated WM_NAME and exit
  -s, --stdout                 Output data to stdout instead of drawing it to the X window
  -p, --png=FILE               Save png snapshot to FILE after running for 3 seconds
```

*Also see [`man 1 polybar`](https://polybar.readthedocs.io/man/polybar.1.html).*

By default, polybar will load the config file from
`~/.config/polybar/config.ini`, `/etc/xdg/polybar/config.ini`, or
`/etc/polybar/config.ini` depending on which it finds first.

If you do not specify the name of the bar and your config file only contains a
single bar, polybar will display that bar.
Otherwise you have to explicitly specify bar name.
For example the following command is used to display the bar defined in the
`[bar/mybar]` section in the config.

```sh
polybar mybar
```

## Launching the bar in your wm's bootstrap routine

Create an executable file containing the startup logic, for example `$HOME/.config/polybar/launch.sh`:
```sh
#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown

echo "Bars launched..."
```

Make sure you use the name(s) of the bar(s) from your config.

Make it executable:
```sh
$ chmod +x $HOME/.config/polybar/launch.sh
```

If you are using **bspwm**, add the following line to `bspwmrc`:
```sh
$HOME/.config/polybar/launch.sh
```

If you are using **i3**, add the following lines to your configuration:
```sh
exec_always --no-startup-id $HOME/.config/polybar/launch.sh
```

and remove these
```sh
bar {
    i3bar_command i3bar
}
```
The first line executes the startup script; the second disables i3's default bar 

## Override monitor

By defining a reference to an environment variable you could override the monitor at launch:
```dosini
[bar/mybar]
monitor = ${env:MONITOR:fallback-value}
....
```
```sh
$ MONITOR=override-value polybar mybar
```

### Dealing with XRandR 1.5+ randomized monitor names
If your polybar configuration uses the `monitor` configuration variable and sometimes fails to start because XRandR 1.5+ is creating randomized monitor names, you can fix this by specifying the `MONITOR` environment variable as shown above, and setting it in your launch.sh script like this:

```sh
MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')
```

## i3: Make the bar appear below windows

To allow other windows to be placed above the bar, or to avoid having the bar visible when in fullscreen mode, you need to use the following two parameters. Note that it will tell the window manager to back off so no area will be reserved, etc.

```dosini
[bar/mybar]
override-redirect = true
wm-restack = i3
```
