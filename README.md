# Tizen SDK for Nix
    
<img src=".assets/logo.png" alt="Tizen SDK for Nix logo" width="197" height="197" float="right" align="right">
    
This is a work-in-progress flake that allows fetching and using *some* Tizen SDK
components using Nix.

This implementation is work-in-progress and currently doesnt implement anything
except automatically generated `fetchurl`-based package fetchers for packages
from <https://download.tizen.org/sdk/tizenstudio/> distributions.

It can be used for supplying Tizen-based Rootstraps and some small, individual
components, for example SDB, but **cannot be used to run full Tizen SDK
and/or Tizen Studio yet**.

More properly wrapped packages for some of the components might be coming soon.

## Wrapped packages

- `sdb`: Smart Development Bridge

## Usage

This flake provides all packages available in snapshots found on
<https://download.tizen.org/sdk/tizenstudio/official/snapshots/>

This is supposed to be used in conjunction with `pkgs.symlinkJoin` to create a
complete Tizen SDK environment needed for your task.

The naming convention of auto-generated dist packages is as follows:

`tizen-sdk.distribution.<distribution>.<snapshot>.<os>.<package>`

For example, to build the Ubuntu 64-bit version of the
`wearable-2.3-emulator-qemu-skins` package from `Tizen_Studio_5.6` snapshot
(using the `official` distribution):

```bash
nix build .#tizen-sdk.distribution.official.Tizen_Studio_5_6.ubuntu-64.wearable-2_3-emulator-qemu-skins
```

(Dots are replaced with underscores in the package/snapshot names;
Also, pease note that all of the packages in this flake are marked as
`unfree`/`unfreeRedistributable`, so you may need to enable `allowUnfree` in your
Nix configuration)

## Updating

To update the index, run the provided `generate_index.nu` script
at the root of this repository.

You shouldn't need anything except Nushell to run it.

🏳️‍⚧️
