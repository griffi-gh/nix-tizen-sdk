# Tizen SDK for Nix

This is a work-in-progress flake that allows fetching and using *some* Tizen SDK
components using Nix.

This implementation is work-in-progress and currently doesnt implement anything
except automatically generated `fetchurl`-based package fetchers for packages
from <https://download.tizen.org/sdk/tizenstudio/> distributions.

It can still be useful for e.g. supplying Tizen-based Rootstraps/rootfs and maybe
small individual components, like sdb but cannot be used to run full Tizen SDK
and/or Tizen Studio

## Usage

This flake provides all packages available in snapshots found on <https://download.tizen.org/sdk/tizenstudio/official/snapshots/>

For example, to fetch the Ubuntu 64-bit version of the
`wearable-2_3-emulator-qemu-skins` package from `Tizen_Studio_5_6` snapshot:

```bash
nix build .#tizen-sdk.distribution.official.Tizen_Studio_5_6.ubuntu-64.wearable-2_3-emulator-qemu-skins
```

(Please note that all of the packages in this flake are marked as
`unfree`/`unfreeRedistributable`, so you may need to enable `allowUnfree` in your
Nix configuration and/or `allowRedistributable`)

## Updating

To update the index, run the provided `generate_index.nu` script
at the root of this repository.

You shouldn't need anything except Nushell to run it.
