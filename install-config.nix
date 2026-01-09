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

    # Enable LUKS encryption for ROOT filesystem (true/false)
    useLuks = false;

    # Enable random encryption for swap (true/false)
    # Independent of root encryption - can encrypt swap without encrypting root
    encryptSwap = true;

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
        options = [ "compress=zstd" "noatime" ];
      };
      "/home" = {
        # Home subvolume with compression
        options = [ "compress=zstd" "noatime" ];
      };
      "/nix" = {
        # Nix store subvolume with lighter compression
        options = [ "noatime" "compress=zstd:1" ];
      };
      "/var" = {
        # Var subvolume with compression
        options = [ "compress=zstd" "noatime" ];
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
