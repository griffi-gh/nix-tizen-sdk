# Tizen SDK for Nix
    
<img src=".assets/logo.png" alt="Tizen SDK for Nix logo" width="197" height="197" float="right" align="right">
    
This is a work-in-progress flake that allows fetching/using *some* Tizen SDK
components using Nix.

It can be used for supplying Tizen-based Rootstraps and some small, individual
components, for example SDB, but **cannot be used to run full Tizen SDK
and/or Tizen Studio yet**.

More properly wrapped packages for some of the components might be coming soon.

## Usage

For example, to create a Tizen Studio 5.6 environment with
`sdb` and `COMMON-MANDATORY` components, you can use:

```nix
tizen-studio-5_x.mkTizenSdk [
  "COMMON-MANDATORY"
  "sdb"
];
```

## Wrapped packages

Currently, we support latest SDK and (deprecated) Tizen Studio 5.x, 6.x.

SDKs:


- `tizen-studio-5_x` - Tizen Studio 5.x
- `tizen-studio-6_x` - Tizen Studio 6.x
- `tizen-sdk-10_x` - Tizen SDK 10.x (latest)
- `tizen-sdk` (alias of `tizen-sdk-10_x`)
  - `mkTizenSdk`: Builds final Tizen SDK path from individual components
  - `wrapper.*`: Wrapped distribution components
    - `sdb` - Smart Debug Bridge (standalone)
 
- `tizen-sdk-distribution` - Raw/unwrapped Tizen SDK distribution packages

Aliases:

- `sdb` (alias of `tizen-sdk.wrapper.sdb`)

(most packages you'd need are probably not wrapped yet, scroll down a bit lower
to see how to use distribution packages from `legacyPackages.tizen-sdk-distribution.*`)

## Auto-generated distribution packages

This flake provides all packages available in snapshots found on
<https://download.tizen.org/sdk/tizenstudio/official/snapshots/> (as well as
[tizen_studio_source](https://download.tizen.org/sdk/tizenstudio/tizen_studio_source/snapshots/))
as auto-generated Nix fetchurl derivations.

In most cases, you should use `mkTizenSdk` to combine distribution packages,
and never touch them directly, as it handles dependencies and wrapping for you.

The naming convention of auto-generated dist packages is as follows:

`tizen-sdk-distribution.<distribution>.<snapshot>.<os>.<package>`

For example, to build the Ubuntu 64-bit version of the
`wearable-2.3-emulator-qemu-skins` package from `Tizen_Studio_5.6` snapshot
(using the `official` distribution):

```bash
nix build .#tizen-sdk-distribution.official.Tizen_Studio_5_6.ubuntu-64.wearable-2_3-emulator-qemu-skins
```

(Dots are replaced with underscores in the package/snapshot names;
Also, pease note that all of the packages in this flake are marked as
`unfree`/`unfreeRedistributable`, so you may need to enable `allowUnfree` in your
Nix configuration)

The SDK root is at `/opt/tizen-studio` inside the package's output to avoid conflicts.

## Updating

To update the index, run the provided `generate_index.nu` script
at the root of this repository.

(You shouldn't need anything except Nushell to run it.)

🏳️‍⚧️
