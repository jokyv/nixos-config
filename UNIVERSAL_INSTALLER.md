# Universal NixOS Installer

This guide explains how to use the universal installer that automatically detects the first disk and applies your configuration.

## Quick Start

1. **Configure your system** by editing `install-config.nix`
2. **Boot from NixOS Live USB**
3. **Clone this repository**
4. **Run the installer**

## Configuration

Edit `install-config.nix` at the root of this repository:

```nix
{
  # Host name for the system
  hostname = "nixos";

  # Disk configuration
  disk = {
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
      "/tmp" = { };
    };
  };

  # Ext4 settings (only used if filesystem = "ext4")
  ext4 = {
    filesystemLabel = "nixos";
    mountOptions = [ "noatime" ];
  };
}
```

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

### 3. Edit Configuration

Edit `install-config.nix` with your preferred settings:
```bash
nano install-config.nix
```

Common configurations:
- For no encryption: `useLuks = false;`
- For ext4 filesystem: `filesystem = "ext4";`
- For different swap size: `swapSize = "16G";`

### 4. Run the Installer

The universal installer will automatically detect the first disk:
```bash
# Format and install NixOS
sudo nix run --experimental-features "nix-command flakes" github:nix-community/disko -- --mode disko --flake .#nixos
```

### 5. Set Password and Reboot

Set a password for your user:
```bash
# You'll be asked for this during the next boot
sudo nixos-install --no-root-password --flake .#nixos

# Or add temporary password in hosts/jokyv/default.nix
# Then remove it after first boot
```

Reboot the system:
```bash
sudo reboot
```

### 6. Post-Installation

After the first boot:
```bash
# Clone the repository for Home Manager
git clone https://github.com/jokyv/nixos-config.git ~/nixos-config
cd ~/nixos-config

# Apply Home Manager configuration
home-manager switch --flake .#jokyv
```

## Filesystem Options

### Btrfs (Recommended)
- Advantages: Snapshots, compression, subvolumes
- Default subvolumes: /, /home, /nix, /var/log, /tmp
- Built-in compression for better space efficiency

### Ext4
- Advantages: Simple, reliable, widely supported
- No built-in snapshots or compression
- Simpler structure for basic setups

### Encryption (LUKS)
- Encrypts the root partition (not EFI or swap)
- You'll be prompted for password on every boot
- Swap uses random encryption when enabled

## Troubleshooting

### ERROR: No disks found!
If you see this error during installation:

1. **Check you're on actual hardware** (not in a container/VM)
2. **Verify disks are detected**: `lsblk`
3. **Check permissions**: Ensure you can access `/dev/disk/by-diskseq/`

If the issue persists, manually specify the disk:
1. Edit `disks/universal-config.nix`
2. Find the `device = "/dev/disk/by-diskseq/1";` line
3. Change it to your disk (e.g., `"/dev/sda"` or `"/dev/nvme0n1"`)

### Wrong Disk Selected?
The installer uses `/dev/disk/by-diskseq/1` (first disk). To select a different disk:
1. List available disks: `lsblk`
2. Edit `disks/universal-config.nix`
3. Change `device = "/dev/disk/by-diskseq/1";` to your desired disk

### Multiple Disks?
The current implementation only handles the first disk. For multi-disk setups, use the legacy configurations in `disks/disk-config-*.nix`.

### Boot Issues?
- Check that the disk is detected: `lsblk`
- Verify EFI partition is mounted: `mount | grep /boot`
- Check encrypted partition: `lsblk -f`

## Directory Structure

```
nixos-config/
├── install-config.nix          # Your configuration
├── disks/
│   ├── universal-config.nix     # Auto-detecting disk config
│   ├── disk-config-btrfs-luks.nix  # Legacy Btrfs+LUKS
│   └── disk-config-btrfs.nix       # Legacy Btrfs
└── hosts/
    └── jokyv/
        └── default.nix           # Uses universal-config.nix
```

## Adding New Hosts

To add a new host:
1. Create `hosts/new-host/default.nix`
2. Copy from `hosts/jokyv/default.nix`
3. Import `../../disks/universal-config.nix`
4. Adjust host-specific settings
5. Edit `install-config.nix` before installing