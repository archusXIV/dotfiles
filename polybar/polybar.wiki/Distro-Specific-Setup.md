This page contains tips for setting up your polybar environment in different
distros, contributed by the community.
Also check out the [developer
documentation](https://polybar.readthedocs.io/en/latest/dev/getting-started.html).

If you run into any quirks in your distro, feel free to document them here.

## Nix

You don't need the Nix distro to use the following, just the Nix package manager. 
It can be installed in any Linux distro and Mac OS.

How to use:

* Enable Flakes support in your Nix installation.
* `git clone` the polybar repo and create the below two files (flake.nix, flake.lock) in the root of the repo.
* Run `nix develop`

This will drop you into a shell with all the packages needed for polybar development installed.

<details>
<summary>flake.nix</summary>

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      devShell.x86_64-linux =
        pkgs.mkShell {
          buildInputs = with pkgs; [
            alsaLib
            cairo.dev
            cmake
            curl.dev
            i3
            jsoncpp.dev
            libmpdclient
            libpulseaudio
            libuv
            pkg-config
            sphinx
            wirelesstools
            xorg.libxcb
            xorg.xcbproto
            xorg.xcbutilimage
            xorg.xcbutilwm.dev
          ];
        };
    };
}
```
</details>

<details>
<summary>flake.lock</summary>

```json
{
  "nodes": {
    "nixpkgs": {
      "locked": {
        "lastModified": 1648400941,
        "narHash": "sha256-82VdFzqvRY7oRVQyHW7+BYtwdOVH5hmVysYSV/SecF0=",
        "owner": "NixOS",
        "repo": "nixpkgs",
        "rev": "d56076aa39859f675bbdc64ea148664406db3278",
        "type": "github"
      },
      "original": {
        "owner": "NixOS",
        "repo": "nixpkgs",
        "type": "github"
      }
    },
    "root": {
      "inputs": {
        "nixpkgs": "nixpkgs"
      }
    }
  },
  "root": "root",
  "version": 7
}
```

</details>
