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

## Verify after install

```bash
nixos-rebuild switch --flake .#nixos
findmnt /tmp
lsblk -f
systemctl --failed
```

## Troubleshooting

- No disks found → check `lsblk`
- Wrong disk → set `disk.device` in matching `install/*.nix`
- Boot issues → check `/boot`, `lsblk -f`, `hardware-configuration.nix`
