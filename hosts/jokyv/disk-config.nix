{ lib, ... }:

{
  disko.devices = {
    disk = {
      main = {
        # IMPORTANT: Change this to your actual disk device.
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
              };
            };
            # Create a btrfs partition with the rest of the space
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "nixos" ]; # Label the filesystem
                subvolumes = {
                  # Create a subvolume for the root filesystem
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Create a subvolume for the home directory
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
