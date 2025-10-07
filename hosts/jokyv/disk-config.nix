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
              };
            };
            swap = {
              size = "16G"; # Adjust size as needed, e.g. to match RAM size for hibernation
              content = {
                type = "swap";
                # Recommended for security, creates an encrypted swap space
                randomisedEncryption = true;
              };
            };

            # Create a btrfs partition with the rest of the space

            # --------------------------------------------------------------------
            # --- Encrypted BTRFS Partition (LUKS) - UNCOMMENT TO USE ---
            # To enable, remove the /* and */ block comments around this section,
            # and add them around the unencrypted section below.
            # --------------------------------------------------------------------
            /*
              root = {
                size = "100%"; # disko will assign the rest of the space to this partition
                content = {
                  type = "luks";
                  name = "crypted"; # This will be the name of the unlocked device
                  # You will be prompted for a password during installation and on every boot.
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
                      # Create a subvolume for the Nix store
                      "/@nix" = {
                        mountpoint = "/nix";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                    };
                  };
                };
              };
            */

            # ----------------------------------------------------------------------
            # --- Unencrypted BTRFS Partition - COMMENT OUT IF USING LUKS ---
            # ----------------------------------------------------------------------
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
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  # Isolate variable data to prevent logs or containers
                  # from filling up the root filesystem.
                  # "/@var" = {
                  #   mountpoint = "/var";
                  #   mountOptions = [ "compress=zstd" "noattime" ];
                  #   btrfs.quota.size = "20G"; # max limit for subvolume
                  # };
                };
              };
            };
          };
        };
      };
    };
    # Define filesystems that are not directly on a disk partition.
    filesystems = {
      # Mount /tmp in RAM for performance and to reduce SSD writes.
      "/tmp" = {
        type = "tmpfs";
        # Options: "defaults" is standard, "size" sets a max limit (it doesn't
        # reserve the space), and "mode=1777" sets the correct permissions.
        options = [
          "defaults"
          "size=4G"
          "mode=1777"
        ];
      };
    };
  };
}
