{
  # Universal installer configuration
  # Edit this file before running the installer

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
        options = [ "noatime" "compress-force=zstd:1" "nodatacow" ];
      };
      "/var/log" = {
        # Log subvolume with compression
        compression = "zstd";
      };
      "/tmp" = {
        # Temp subvolume
      };
    };
  };

  ext4 = {
    filesystemLabel = "nixos";
    # Ext4-specific mount options
    mountOptions = [ "noatime" ];
  };
}