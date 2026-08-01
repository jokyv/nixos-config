# Recovery Guide

## Overview

This guide covers recovery for the current `nixos` host:

- UEFI firmware
- systemd-boot
- `/dev/nvme0n1p1` mounted at `/boot`
- `/dev/nvme0n1p3` mounted as Btrfs subvolumes
- unencrypted root filesystem
- no TPM 2.0 device

Do not use these device paths on another machine without checking `lsblk -f` first.

## Before security changes

Keep one known-good NixOS generation bootable. Before applying bootloader or authentication changes:

```bash
nixos-rebuild boot --flake .#nixos
nixos-rebuild list-generations
systemctl --failed
```

Reboot and select the new generation from systemd-boot. Confirm the system works before removing older generations.

Keep the previous generation available until recovery testing succeeds.

## Recovery USB

Create a bootable NixOS installer USB from a trusted machine. Boot it in UEFI mode and verify:

- Keyboard works.
- The internal disk appears.
- The EFI partition mounts.
- The Btrfs filesystem mounts.
- Network works when required.
- This repository or a local copy is available.

Do not test recovery only by creating the USB. Perform a cold boot from it.

## Inspect disks from recovery media

```bash
lsblk -f
findmnt
```

Identify the EFI partition and Btrfs partition from this output. Current host values are `/dev/nvme0n1p1` and `/dev/nvme0n1p3`.

## Mount current system

The current host uses these Btrfs subvolumes:

- `@` → `/`
- `@home` → `/home`
- `@nix` → `/nix`
- `@var` → `/var`

Example recovery mounts:

```bash
mount -o subvol=@ /dev/nvme0n1p3 /mnt
mount --mkdir -o subvol=@home /dev/nvme0n1p3 /mnt/home
mount --mkdir -o subvol=@nix /dev/nvme0n1p3 /mnt/nix
mount --mkdir -o subvol=@var /dev/nvme0n1p3 /mnt/var
mount --mkdir /dev/nvme0n1p1 /mnt/boot
```

Replace device paths after inspecting the recovery environment.

## Boot recovery

1. Reboot into systemd-boot.
2. Select a previous known-good generation.
3. If no usable generation boots, start the recovery USB.
4. Mount the filesystems as described above.
5. Preserve logs and configuration before attempting repairs.

Do not delete generations or reformat disks during initial recovery.

## Secrets and credentials

Keep these outside Git and outside the target disk:

- SOPS age key
- LUKS recovery material, if encryption is added later
- Secure Boot keys, if Secure Boot is enabled later
- FIDO2 backup credential, if FIDO2 is enabled later

The current host has no TPM and no encrypted root LUKS mapping. Do not follow future FIDO2-LUKS or TPM recovery steps until those features are explicitly configured and tested.

## Recovery test record

Record results after testing:

- Recovery USB boots in UEFI mode: TODO
- Internal disk identified: TODO
- Filesystems mounted: TODO
- Known-good generation boots: TODO
- Configuration repository available offline: TODO
- Network recovery tested: TODO

Review placeholders, verify commands, add missing examples.
