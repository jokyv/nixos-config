# Installation Guide

This guide explains how to install my NixOS configuration.

## Quick Start

1. **Configure my system** by editing `install-config.nix`
2. **Boot from NixOS Live USB**
3. **Clone this repository**
4. **Run the installer**

---

## Configuration

Edit `install-config.nix` at the root of this repository:

```nix
{
  # Disk configuration
  disk = {
    # Device to use (null = auto-detect first disk during installation)
    # Set to specific device if needed, e.g., "/dev/nvme0n1"
    device = null;

    # Filesystem type: "btrfs" or "ext4"
    filesystem = "btrfs";

    # Enable LUKS encryption (true/false)
    useLuks = true;

    # Partition sizes
    swapSize = "32G";      # Swap partition size
    efiSize = "512M";      # EFI partition size

    # Encryption settings (only used if useLuks = true)
    luks = {
      name = "crypted";    # Name for the encrypted volume
    };
  };

  # Btrfs settings (only used if filesystem = "btrfs")
  btrfs = {
    filesystemLabel = "nixos";
    subvolumes = {
      "/" = { };
      "/home" = {
        compression = "zstd";
      };
      "/nix" = {
        options = [ "noatime" "compress-force=zstd:1" "nodatacow" ];
      };
      "/var/log" = {
        compression = "zstd";
      };
    };
  };

  # Ext4 settings (only used if filesystem = "ext4")
  ext4 = {
    filesystemLabel = "nixos";
    mountOptions = [ "noatime" ];
  };

  # Tmpfs configuration
  tmpfs = {
    enable = true;
    size = "4G";
    mode = "1777";
  };
}
```

**Note**: The hostname should be set in `hosts/<your-host>/default.nix`, NOT in `install-config.nix`.

Common configurations:

- For no encryption: `useLuks = false;`
- For ext4 filesystem: `filesystem = "ext4";`
- For different swap size: `swapSize = "16G";`

---

## Installation Steps

### 1. Boot from NixOS Live USB

Download and flash the latest NixOS minimal ISO:

```bash
# Download NixOS ISO
wget https://channels.nixos.org/latest-nixos-minimal-x86_64-linux.iso

# Flash to USB (replace /dev/sdX with your USB device)
sudo dd if=nixos-minimal-x86_64-linux.iso of=/dev/sdX bs=4M conv=fsync status=progress
```

### 2. Prepare the System

Boot from the USB and ensure you have internet:

```bash
# Test internet connection
ping google.com

# Clone this repository
git clone https://github.com/jokyv/nixos-config.git /tmp/nixos-config
cd /tmp/nixos-config
```

### 3. Set Hostname

Edit `hosts/jokyv/default.nix` and set your hostname:

```nix
networking.hostname = "nixos";  # Change to your preferred hostname
```

### 4. (One-time) Add disko to host config

**IMPORTANT**: For installation ONLY, temporarily add disko to your host config:

In `hosts/jokyv/default.nix`, add these lines to the `imports` array:

```nix
imports = [
  inputs.disko.nixosModules.disko
  ../../disks/universal-config.nix
  # ... rest of your imports
];
```

**You must remove these after installation!** See Post-Installation below.

### 5. Set User Password

Choose one of these methods:

**Option A: Temporary password (simple)**

```nix
# In hosts/jokyv/default.nix, add:
users.users.jokyv.initialPassword = "changeme";
```

Remove this line after first boot and set a proper password with `passwd`.

**Option B: sops-nix (secure, recommended)**

```nix
# Import sops module
import = [ inputs.sops-nix.nixosModules.sops ]

# Define the secret
sops.secrets."pass_jokyv" = { };

# Use it for user password
users.users.jokyv.passwordFile = config.sops.secrets."pass_jokyv".path;
```

### 6. Run the Installer

The universal installer will automatically detect the first disk:

```bash
# Format and install NixOS
sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko -- --mode disko --flake .#nixos
```

The installer will automatically format and partition the first available disk.

### 7. Install NixOS

```bash
sudo nixos-install --no-root-password --flake .#nixos
```

### 8. Reboot

```bash
sudo reboot
```

Remove the USB stick when the computer turns off.

---

## Option 2: Legacy Manual Configuration

If you need to select a specific disk or use a legacy configuration:

1. Use `lsblk` to identify the disk name
2. Modify the appropriate disk config file in `disks/` directory:
   - `disk-config-btrfs-luks.nix` - Btrfs with LUKS encryption
   - `disk-config-btrfs.nix` - Btrfs without encryption
3. Run the same disko command as above

---

## Post-Installation: CRITICAL STEP

After booting into your new system, you **must** remove disko from the host configuration to prevent issues with future rebuilds:

```bash
# Edit hosts/jokyv/default.nix
nano ~/nixos-config/hosts/jokyv/default.nix
```

Remove these lines from the `imports` array:

```nix
inputs.disko.nixosModules.disko
../../disks/universal-config.nix
```

Then verify the configuration works:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

---

## Verify Disko Installation

Check that disko has set up everything correctly:

```bash
# Verify tmpfs is mounted
findmnt /tmp

# Verify /var subvolume
findmnt /var

# List all btrfs subvolumes
sudo btrfs subvolume list /
```

---

## Set up Home Manager

```bash
# Clone the repository
git clone git@github.com:jokyv/nixos-config.git ~/nixos-config
cd ~/nixos-config

# Install home-manager temporarily
nix shell -p home-manager

# Apply Home Manager configuration
home-manager switch --flake .#jokyv

# Or use just (if you have justfile installed)
just home
```

---

## Post-installation Script

After installation, you may want to:

1. **Symlink configurations** for tools like `aider-chat`
2. **Symlink configs to `.config`** - for example, `ruff.toml` for Python linting
3. **Set up your development environment** using devenv/direnv (already included)

---

## Filesystem Options

### Btrfs (Recommended)

- Advantages: Snapshots, compression, subvolumes
- Default subvolumes: /, /home, /nix, /var/log
- Built-in compression for better space efficiency
- Supports rollback and system snapshots

### Ext4

- Advantages: Simple, reliable, widely supported
- No built-in snapshots or compression
- Simpler structure for basic setups

### Encryption (LUKS)

- Encrypts the root partition (not EFI or swap)
- You'll be prompted for password on every boot
- Swap uses random encryption when enabled

---

## Troubleshooting

### ERROR: No disks found!

If you see this error during installation:

1. **Check you're on actual hardware** (not in a container/VM)
2. **Verify disks are detected**: `lsblk`
3. **Check permissions**: Ensure you can access `/dev/disk/by-diskseq/`

If the issue persists, manually specify the disk in `install-config.nix`:

```nix
disk = {
  device = "/dev/nvme0n1";  # or /dev/sda
  ...
};
```

### Wrong Disk Selected?

The installer uses `/dev/disk/by-diskseq/1` (first disk) by default. To select a different disk, edit `install-config.nix`:

```nix
disk.device = "/dev/nvme0n1";  # Your specific disk
```

### Multiple Disks?

The universal installer handles the first disk. For multi-disk setups, use the legacy configurations in `disks/disk-config-*.nix`.

### Boot Issues?

- Check that the disk is detected: `lsblk`
- Verify EFI partition is mounted: `mount | grep /boot`
- Check encrypted partition: `lsblk -f`
- Ensure you removed disko/universal-config from imports after installation

---

## Directory Structure

```
nixos-config/
├── install-config.nix          # Installation configuration (disk, fs, encryption)
├── disks/
│   └── universal-config.nix    # Auto-detecting disk config (for installation only)
├── hosts/
│   └── jokyv/
│       ├── default.nix         # Host configuration (does NOT import universal-config)
│       └── hardware-configuration.nix  # Generated hardware config with mount points
└── docs/
    └── installation.md         # This file
```

**Important**: `universal-config.nix` is ONLY used during installation. Normal rebuilds use `hardware-configuration.nix` for filesystem mounts.

---

## Adding New Hosts

To add a new host:

1. Create `hosts/new-host/default.nix`
2. Copy from `hosts/jokyv/default.nix`
3. Set `networking.hostname` to the new hostname
4. Adjust host-specific settings
5. For installation: temporarily add `inputs.disko.nixosModules.disko` and `../../disks/universal-config.nix` to imports, then remove after installation
6. Edit `install-config.nix` before installing (disk, filesystem, encryption settings)

Then add to `flake.nix`:

```nix
nixosConfigurations = {
  jokyv = nixpkgs.lib.nixosSystem { modules = [ ./hosts/jokyv/default.nix ... ]; };
  new-host = nixpkgs.lib.nixosSystem { modules = [ ./hosts/new-host/default.nix ... ]; };
};
```
