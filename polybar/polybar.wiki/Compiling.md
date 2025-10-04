Please [report any problems](https://github.com/polybar/polybar/discussions/categories/build-support) 
you run into when building the project.

Click [here](/polybar/polybar#getting-started) to check if polybar was already 
packaged for your distro.

## Table of Contents

* [Dependencies](#dependencies)
  * [Build Dependencies](#build-dependencies)
  * [Dependencies](#dependencies-1)
  * [Optional Dependencies](#optional-dependencies)
* [Building](#building)
  * [Compiling](#compiling)
  * [Building with clang](#building-with-clang)
  * [BSD](#bsd)
* [Uninstalling](#uninstalling)

## Dependencies

Here is a quick rundown of packages polybar needs to build and run correctly. 
See further below for more details and concrete package names for different
distros.

A compiler with C++17 support ([clang-7+](https://llvm.org/releases/download.html), [gcc-8+](https://gcc.gnu.org/releases.html)), [cmake 3.5+](https://cmake.org/download/), [git](https://git-scm.com/downloads)
- `pkg-config`
- `libuv`
- `cairo`
- `libxcb`
- `python3`
- `xcb-proto`
- `xcb-util-image`
- `xcb-util-wm`
- `python-sphinx`
- `python-packaging`

**Optional dependencies:**
- `xcb-util-cursor` *required for the `cursor-click` and `cursor-scroll` settings*
- `xcb-util-xrm` *required for accessing X resources with `${xrdb:...}`*

**Optional dependencies for extended module support:**
- `xcb-xkb` *required by `internal/xkeyboard`*
- `alsa-lib` *required by `internal/alsa`*
- `libpulse` *required by `internal/pulseaudio`*
- `i3-wm` and `jsoncpp` *required by `internal/i3`*
- `libmpdclient` *required by `internal/mpd`*
- `libcurl` *required by `internal/github`*
- `libnl-genl` or `wireless_tools` *required by `internal/network`*

### Build Dependencies
The following dependencies are only needed during compilation, you can remove them, if you don't need them, after you built polybar

| Build Dependency | apt-get | Fedora | openSUSE |
| ---------- | ------- | ------ | -------- |
| gcc/g++ >= 8 | `g++` | `gcc-c++` | `gcc` |
| clang >= 7 | `clang` | `clang` | `clang` |
| git<sup>1</sup> | `git` | `git` | `git` |
| cmake >= 3.5 | `cmake`  <br />`cmake-data` | `cmake` <br />`@development-tools` | `cmake` |
| pkg-config | `pkg-config` | - | - |
| python3 | `python3` | `python3` | `python3` |
| [sphinx](https://www.sphinx-doc.org/en/master/usage/installation.html) | `python3-sphinx` | `python3-sphinx` | `python3-Sphinx` |
| python-packaging | `python3-packaging` |`python3-packaging` |`python3-packaging` |

<sup>1</sup> Only needed when not using the release archives  

**Note:** You only need either `gcc` or `clang`.

All above dependencies paste-friendly for dnf (includes both `gcc` and `clang`):
```bash
sudo dnf install -y gcc-c++ clang git cmake @development-tools python3-sphinx python3-packaging
```

### Dependencies
These are the hard dependencies, you cannot build or run polybar without them:

| Dependency | apt-get | Fedora | openSUSE |
| ---------- | ------- | ------ | -------- |
| [libuv](https://github.com/libuv/libuv) >= 1.3 | `libuv1-dev` | `libuv-devel` | `libuv-devel` |
| cairo | `libcairo2-dev` | `cairo-devel` | `cairo-devel` |
| libxcb | `libxcb1-dev` <br />`libxcb-util0-dev` <br />`libxcb-randr0-dev` <br />`libxcb-composite0-dev` | `xcb-util-devel` <br />`libxcb-devel` | `xcb-util-devel` <br />`libxcb-devel` |
| xcb-proto | `python3-xcbgen`<sup>1</sup>  <br />`xcb-proto` | `xcb-proto` | `xcb-proto-devel` |
| xcb-util-image | `libxcb-image0-dev` | `xcb-util-image-devel` | `xcb-util-image-devel` |
| xcb-util-wm | `libxcb-ewmh-dev` <br />`libxcb-icccm4-dev` | `xcb-util-wm-devel` | `xcb-util-wm-devel` |

<sup>1</sup> Before Ubuntu 20.04 (focal) and Debian 11 (bullseye), you need to install the `python-xcbgen` package because the `python3-xcbgen` package does not exist for those versions.

All above dependencies paste-friendly for apt:
```bash
apt install build-essential git cmake cmake-data pkg-config python3-sphinx python3-packaging libuv1-dev libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev
```

All above dependencies paste-friendly for dnf:
```bash
sudo dnf install -y cairo-devel libuv-devel xcb-util-devel libxcb-devel xcb-proto xcb-util-image-devel xcb-util-wm-devel
```

### Optional Dependencies

These dependencies enable optional features in polybar, if they are installed during compilation:

| Optional Dependency | Required for | apt-get | Fedora | openSUSE |
| --------------------- | ------------ | ------- | ------ | -------- |
| xcb-xkb | `internal/xkeyboard` | `libxcb-xkb-dev` | - | `libxcb-xkb1` |
| xcb-util-xrm | `${xrdb:...}` | `libxcb-xrm-dev` | `xcb-util-xrm-devel` | `xcb-util-xrm-devel` |
| xcb-util-cursor | `cursor-click` <br />`cursor-scroll` | `libxcb-cursor-dev` | `xcb-util-cursor-devel` | `xcb-util-cursor-devel` |
| alsa-lib | `internal/alsa` | `libasound2-dev` | `alsa-lib-devel` | `alsa-devel` |
| libpulse | `internal/pulseaudio` | `libpulse-dev` | `pulseaudio-libs-devel` | `libpulse-devel` |
| i3-wm | `internal/i3` | `i3-wm`  | `i3-devel` | `i3-devel` |
| jsoncpp | `internal/i3` | `libjsoncpp-dev` | `jsoncpp-devel` | `jsoncpp-devel` |
| libmpdclient | `internal/mpd` | `libmpdclient-dev` | `libmpdclient-devel` | `libmpdclient-devel` |
| libcurl | `internal/github` | `libcurl4-openssl-dev` <br /> (or `libcurlpp-dev`) | `libcurl-devel` | `libcurl-devel` |
| wireless_tools (deprecated)<sup>1</sup> | `internal/network` | `libiw-dev` | - | `wireless-tools` <br />`libiw-devel` |
| libnl-genl<sup>1<sup> | `internal/network` | `libnl-genl-3-dev` | `libnl3-devel` | `libnl3-devel` |

<sup>1</sup> You only need to install either `libnl-genl` or `wireless-tools`. If `libnl-genl` is installed it will be preferred over `wireless-tools` even if both are installed.

All above dependencies paste-friendly for apt:
```bash
apt install libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev
```

All above dependencies paste-friendly for dnf:
```bash
sudo dnf install -y xcb-util-xrm-devel xcb-util-cursor-devel alsa-lib-devel pulseaudio-libs-devel i3-devel jsoncpp-devel libmpdclient-devel libcurl-devel libnl3-devel
```

**Note:** If you have enabled any optional feature during installation, the dependencies for that feature need to remain installed, otherwise polybar may not start.

## Building
When building polybar from source, you can either download the polybar source code 
from a release archive or directly from the git repository.

**Release Archive**

Download the release archive `polybar-<version>.tar.gz` over at our 
[release page](https://github.com/polybar/polybar/releases) and extract it with 
`tar xvzf polybar-<version>.tar`. Now change into the extracted folder 
(generally `cd polybar-<version>`)

**Repository**

To get the sources directly from the repository, run the following commands:

**Warning:** Compiling polybar this way will give you the latest unreleased 
changes, there may be bugs and it may break your config.
```sh
# Make sure to type the `git' command as-is to clone all git submodules too
git clone --recursive https://github.com/polybar/polybar
cd polybar
```

### Compiling
Regardless of how you downloaded the sources, you should now be inside the 
folder where the polybar sources are located.

To compile, run the following commands:

**Note:** If you are using anaconda, run `conda deactivate` before running `cmake`, also see the note on the [Known Issues page](/polybar/polybar/wiki/Known-Issues#building-with-anaconda-installed) if that doesn't work.

**Note:** Similarly, if you are using `pyenv`, you will likely need to use system python during compilation. You can revert to system python in the current directory by executing `pyenv local system` directly before executing `cmake`.

```sh
mkdir build
cd build
cmake ..
make -j$(nproc)
# Optional. This will install the polybar executable in /usr/bin
sudo make install
```

### Building with clang
In some circumstances the compilation might fail when using gcc and you will have to use clang to compile polybar. 

To do that, in the `cmake ..` step above, run the following command instead:
```
cmake -DCMAKE_CXX_COMPILER="clang++" ..
```

### BSD

Polybar was built with linux in mind and does not officially support the BSDs.
That being said, there are a few lines of code to make polybar at least build on FreeBSD. 
So it should be possible to build polybar on FreeBSD using the same process as
on linux (though you may need to pass the
`-DCMAKE_EXE_LINKER_FLAGS="-L/usr/local/lib"` flag to `cmake`).

There are ports available for [OpenBSD](https://openports.se/x11/polybar) and 
[FreeBSD](https://www.freshports.org/x11/polybar), we suggest you use these for installing polybar.

## Uninstalling
If you have installed polybar using a package manager, the package manager will provide the uninstall feature.

If you have manually compiled and installed polybar, go into the `build` folder where you originally ran `make install`. There you can run `sudo make uninstall` to remove all installed files from your system.

**Warning:** `make uninstall` will try to delete all files listed in the `install_manifest.txt` file inside your `build` folder. Make sure you first check that it won't delete any important files.

## CMake Options

*New in version 3.6.0*

Polybar provides a bunch of cmake options to configure which and how components are compiled.

| Flag                | Default     | Effect |
|:--------------------|:------------|:-------|
| `BUILD_POLYBAR`     | `ON`        | Builds the `polybar` executable |
| `BUILD_POLYBAR_MSG` | `ON`        | Builds the `polybar-msg` executable |
| `BUILD_TESTS`       | `OFF`       | Builds the test suite |
| `BUILD_DOC`         | `ON`        | Builds the documentation |
| `BUILD_DOC_HTML`    | `BUILD_DOC` | Builds the html documentation (depends on `BUILD_DOC`) |
| `BUILD_DOC_MAN`     | `BUILD_DOC` | Builds the manpages (depends on `BUILD_DOC`) |
| `BUILD_CONFIG`      | `ON`        | Generates the default config |
| `BUILD_SHELL`       | `ON`        | Generates shell completion files |
| `DISABLE_ALL`       | `OFF`       | Disables all above targets by default. Individual targets can still be enabled explicitly |
| `POLYBAR_FLAGS`     | `''`        | Pass additional flags to the compiler and linker |
