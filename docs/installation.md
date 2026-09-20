# Installation Guide

## Scope

This repository currently declares one install output:

- `jokyv-install` installs host `nixos` for user `jokyv`.

`dora` has no install or runtime output until its target hardware is available.

## Installer interface

Each `.<host>-install` output composes three modules:

```text
Disko layout
host policy
host-specific installer hardware
```

`install/default.nix` is seam for this composition.

| Module                                    | Owns                                        | Must not own                    |
| ----------------------------------------- | ------------------------------------------- | ------------------------------- |
| `disks/universal-config.nix`              | Partitioning, formatting, mount layout      | Host UUIDs                      |
| `hosts/<host>/default.nix`                | Host policy, users, services, desktop       | Disko device selection          |
| `hosts/<host>/installer-hardware.nix`     | Boot-critical kernel modules                | Filesystem UUIDs or mounts      |
| `hosts/<host>/hardware-configuration.nix` | Installed-machine UUIDs and hardware        | Shared or installer disk layout |
| `install/<host>.nix`                      | Disk target and filesystem install settings | Runtime host policy             |

Installer hardware exists so Disko installation can boot target storage without importing an old `hardware-configuration.nix`. Generated hardware configuration contains current filesystem UUIDs; importing it during a fresh format can override new Disko mounts.

## Files

```text
nixos-config/
├── install/
│   ├── default.nix              # Disko + host + installer hardware
│   └── jokyv.nix                # Jokyv disk settings
├── disks/
│   └── universal-config.nix      # Shared Disko layout
├── hosts/
│   ├── jokyv/
│   │   ├── default.nix
│   │   ├── installer-hardware.nix
│   │   └── hardware-configuration.nix
│   └── dora/
│       ├── default.nix
│       └── desktop.nix
└── flake.nix
```

Create Dora’s install settings, installer hardware, and hardware configuration on Dora after its target disk is identified.

## Jokyv installation

Use this flow only when reinstalling current Jokyv machine.

### 1. Boot Live USB and clone repository

Boot NixOS Live USB in UEFI mode.

```bash
git clone https://github.com/jokyv/nixos-config.git /tmp/nixos-config
cd /tmp/nixos-config
```

`/tmp` is suitable for Live USB use. It disappears after reboot.

### 2. Identify target disk

```bash
lsblk -o NAME,SIZE,MODEL,SERIAL,TRAN,TYPE
ls -l /dev/disk/by-id/
```

Identify intended internal disk by model, size, and serial. Do not select Live USB.

Confirm selected stable ID resolves to expected kernel device:

```bash
readlink -f /dev/disk/by-id/<target-disk>
```

### 3. Configure explicit target

Edit Jokyv install settings in cloned repository:

```bash
$EDITOR install/jokyv.nix
```

Set `disk.device` to selected `/dev/disk/by-id/...` path:

```nix
disk.device = "/dev/disk/by-id/<target-disk>";
```

Do not use `/dev/nvme0n1` on a different machine. Confirm selected path names intended physical disk. Disko format is destructive.

### 4. Partition, format, and mount

```bash
sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko -- \
  --mode disko --flake /tmp/nixos-config#jokyv-install
```

### 5. Verify target mounts

Do this before `nixos-install`:

```bash
findmnt -R /mnt
lsblk -f
```

Expected mounts include `/mnt`, `/mnt/boot`, `/mnt/home`, `/mnt/nix`, and `/mnt/var` when configured by Disko.

Expected Btrfs subvolumes:

```text
@      /
@home  /home
@nix   /nix
@var   /var
```

### 6. Install

```bash
sudo nixos-install --no-root-password \
  --flake /tmp/nixos-config#jokyv-install
```

`--no-root-password` is safe only after primary-user password setup. Jokyv root and user accounts have no login password configured. Before reboot:

```bash
sudo nixos-enter --root /mnt -c 'passwd jokyv'
```

### 7. Reboot and verify

Remove Live USB. Boot new systemd-boot entry.

```bash
findmnt /tmp ~/.cache/fontconfig ~/.cache/mesa_shader_cache
lsblk -f
systemctl --failed
```

Clone repository into primary user home after first login. Future runtime rebuilds use:

```bash
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```

Dora remains unprovisioned until its physical target disk is available. Then follow **New host setup**.

## New host setup

For third or unrelated machine, create install-only configuration before running Disko:

1. `hosts/<host>/default.nix` for hostname, user, host policy.
2. `hosts/<host>/installer-hardware.nix` for target boot drivers only.
3. `install/<host>.nix` for explicit `/dev/disk/by-id/...` target and Disko settings.
4. Install `nixosConfigurations."<host>-install"` in `flake.nix`, passing host policy, installer hardware, and install settings to `install/default.nix`.

Run Disko and `nixos-install` with this install output. It does not require a pre-existing `hardware-configuration.nix`.

After first boot:

1. Clone repository into `~/nixos-config`.
2. Generate and verify machine hardware configuration:

   ```bash
   sudo nixos-generate-config --show-hardware-config
   ```

3. Store result at `hosts/<host>/hardware-configuration.nix`. Never copy another host’s UUIDs.
4. Add runtime `nixosConfigurations.<host>` in `flake.nix`, importing host policy and this machine’s hardware configuration.
5. Run `sudo nixos-rebuild switch --flake ~/nixos-config#<host>`.

## Disk settings

### `install/jokyv.nix`

Current machine settings: Btrfs, 32 GiB randomly encrypted swap, 512 MiB EFI partition, unencrypted root.

`dora` has no active install settings. Create `install/dora.nix` only on Dora after selecting its stable `/dev/disk/by-id/...` target.

## Troubleshooting

- No target disk: run `lsblk -f` and inspect `/dev/disk/by-id/`.
- Wrong target selected: stop before Disko; change `disk.device`.
- Mounts missing after Disko: inspect `findmnt -R /mnt`; do not run `nixos-install`.
- Boot fails: check `/boot`, `lsblk -f`, and host-specific `hardware-configuration.nix`.
