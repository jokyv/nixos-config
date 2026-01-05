{
  # Universal installer configuration
  # Edit this file before running the installer

  # Disk configuration
  disk = {
    # Device to use (null = auto-detect first disk during installation)
    # Set to specific device for installed systems
    device = "/dev/nvme0n1";

    # Filesystem type: "btrfs" or "ext4"
    filesystem = "btrfs";

    # Partition sizes
    swapSize = "32G"; # Swap partition size
    efiSize = "512M"; # EFI partition size

    # Enable LUKS encryption (true/false)
    useLuks = false;

    # Encryption settings (only used if useLuks = true)
    luks = {
      name = "crypted"; # Name for the encrypted volume
    };
  };

  # Filesystem-specific settings
  btrfs = {
    filesystemLabel = "nixos";
    # Subvolumes for Btrfs (only used if filesystem = "btrfs")
    subvolumes = {
      "/" = {
        # Root subvolume
      };
      "/home" = {
        # Home subvolume with compression
        compression = "zstd";
      };
      "/nix" = {
        # Nix store subvolume with no-atime and no-co for better performance
        options = [
          "noatime"
          "compress-force=zstd:1"
          "nodatacow"
        ];
      };
      "/var/log" = {
        # Log subvolume with compression
        compression = "zstd";
      };
    };
  };

  ext4 = {
    filesystemLabel = "nixos";
    # Ext4-specific mount options
    mountOptions = [ "noatime" ];
  };

  # Tmpfs configuration (independent of filesystem type)
  tmpfs = {
    enable = true; # Enable tmpfs for /tmp
    size = "4G"; # Size limit
    mode = "1777"; # Permissions
  };
}
