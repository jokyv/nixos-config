{ lib, ... }:

{
  disko.devices = {
    disk = {
      main = {
        # Use `lsblk` in the installer to find the correct path.
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # Create a 512MB EFI partition for boot
            ESP = {
              size = "512M";
              type = "EF00"; # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };
            # Swap has a dedicated partition outside btrfs
            # Better performace, reliability, security and btrfs swap have files are not recommended
            swap = {
              size = "32G"; # Adjust size as needed, e.g. to match RAM size for hibernation
              content = {
                type = "swap";
                # Recommended for security, creates an encrypted swap space - Does not work
                randomEncryption = true;
              };
            };

            # Create a btrfs partition with the rest of the space
            root = {
              size = "100%"; # disko will assign the rest of the space to this partition
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "nixos"
                ]; # Label the filesystem
                subvolumes = {
                  # Create a subvolume for the root filesystem
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  # Create a subvolume for the home directory
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  # Create a subvolume for the Nix store
                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                      # "compress=zstd"
                      # No compression at all
                      # "compress=none"
                      # faster compression but less opti
                      "compress=zstd:1"
                    ];
                  };
                  # Isolate variable data to prevent logs or containers
                  # from filling up the root filesystem.
                  "/@var" = {
                    mountpoint = "/var";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=4G"
          "mode=1777"
        ];
      };
    };
  };
}
