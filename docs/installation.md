# Installation Guide

This repo has 2 install paths:

- `jokyv-install` for current machine
- `dora-install` for dora machine

`disko` still handles partitioning.

## Files

```text
nixos-config/
├── install/
│   ├── default.nix        # Install wrapper (disko + host module)
│   ├── jokyv.nix          # Install config for jokyv machine
│   └── dora.nix           # Install config for dora machine
├── disks/
│   └── universal-config.nix  # Shared disk module
├── hosts/
│   ├── jokyv/
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── dora/
│       ├── default.nix
│       ├── desktop.nix
│       └── hardware-configuration.nix
└── flake.nix
```

`hosts/*/default.nix` owns runtime config. `install/default.nix` owns install wiring. `install/*.nix` owns install knobs.

## Install outputs

- `.#jokyv-install` → install `nixos` box / user `jokyv`
- `.#dora-install` → install `dora` box / user `dora`

## Naming policy

- Host names: lowercase, short, stable names; use role-based names for shared machines and person-based names for personal machines.
- User names: lowercase, stable login names; one primary user per personal host by default.
- Install outputs: use the `<profile>-install` suffix. Profile names usually mirror host names but may differ.
- Host and user names may differ. Example: host `nixos` uses user `jokyv`.
- Keep install output names stable; they are flake targets used by installation commands.

Current mapping:

| Runtime host | Primary user | Install output  | Notes                                       |
| ------------ | ------------ | --------------- | ------------------------------------------- |
| `nixos`      | `jokyv`      | `jokyv-install` | Current profile name differs from hostname. |
| `dora`       | `dora`       | `dora-install`  | Profile name matches hostname.              |

New host example: host `lab` with user `jokyv` can use install output `lab-install`.

## Install flow

1. Clone repo
2. Edit matching `install/*.nix`
3. Set hostname in `hosts/<host-name>/default.nix`
4. Boot NixOS Live USB
5. Run `disko` with matching install output
6. Run `nixos-install` with same output
7. Reboot

### Example: dora machine

```bash
sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko -- --mode disko --flake .#dora-install
sudo nixos-install --no-root-password --flake .#dora-install
```

### Example: jokyv

```bash
sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko -- --mode disko --flake .#jokyv-install
sudo nixos-install --no-root-password --flake .#jokyv-install
```

## Install config files

### `install/jokyv.nix`

Current machine install config. Disk set explicit, disk swap on, swap encryption on.

### `install/dora.nix`

Mom PC install config. `disk.device = null` for auto-detect, no disk swap, light tmpfs.

## Host setup

- `nixos` host → user `jokyv`
- `dora` host → user `dora`
- `dora` stays system-only
- `nixos` keeps Home Manager

## Temporary files and caches

`nixos` uses tmpfs for temporary data:

- `/tmp` has a 4 GiB tmpfs and is cleared on reboot.
- `~/.cache/fontconfig` has a 256 MiB tmpfs and rebuilds font caches after reboot.
- `~/.cache/mesa_shader_cache` has a 256 MiB tmpfs and rebuilds GPU shader caches after reboot. First game or graphics application launch may stutter.

Do not store personal files, downloads, projects, or caches needed offline in these paths. Browser, Nix, UV, Puppeteer, and other large caches remain persistent.

Verify mounts after rebuild or install:

```bash
findmnt /tmp ~/.cache/fontconfig ~/.cache/mesa_shader_cache
```

## Verify after install

```bash
nixos-rebuild switch --flake .#nixos
findmnt /tmp ~/.cache/fontconfig ~/.cache/mesa_shader_cache
lsblk -f
systemctl --failed
```

## Troubleshooting

- No disks found → check `lsblk`
- Wrong disk → set `disk.device` in matching `install/*.nix`
- Boot issues → check `/boot`, `lsblk -f`, `hardware-configuration.nix`
