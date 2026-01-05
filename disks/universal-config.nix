{ lib, ... }:

let
  # Import the install-config
  installConfig = import ../install-config.nix;

  # Use the config directly (single-host setup)
  cfg = installConfig;

  # Use device from install-config if specified, otherwise auto-detect first disk
  # Auto-detection uses diskseq which is more reliable than scanning /sys/block
  device =
    if cfg.disk.device != null then
      cfg.disk.device
    else
      "/dev/disk/by-diskseq/1";

in
{
  disko.devices = {
    disk = {
      main = {
        device = device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # EFI partition
            ESP = {
              size = cfg.disk.efiSize;
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };

            # Swap partition
            swap = {
              size = cfg.disk.swapSize;
              content = {
                type = "swap";
                randomEncryption = cfg.disk.useLuks;
              };
            };

            # Root partition
            root = {
              size = "100%";
              content =
                if cfg.disk.useLuks then
                  {
                    type = "luks";
                    name = cfg.disk.luks.name;
                    content = {
                      type = cfg.disk.filesystem;
                      extraArgs = lib.optionals (cfg.disk.filesystem == "btrfs") [
                        "-L"
                        cfg.btrfs.filesystemLabel
                      ];
                      subvolumes = lib.optionalAttrs (cfg.disk.filesystem == "btrfs")
                        (lib.mapAttrs'
                          (name: value:
                            lib.nameValuePair "@${name}" {
                              mountpoint = name;
                              mountOptions =
                                (value.options or [ ])
                                ++ lib.optionals (value ? compression) [ "compress=${value.compression}" ];
                            })
                          cfg.btrfs.subvolumes);
                    };
                  }
                else
                  {
                    type = cfg.disk.filesystem;
                    extraArgs =
                      lib.optionals (cfg.disk.filesystem == "btrfs") [
                        "-L"
                        cfg.btrfs.filesystemLabel
                      ]
                      ++ lib.optionals (cfg.disk.filesystem == "ext4") [
                        "-L"
                        cfg.ext4.filesystemLabel
                      ];
                    subvolumes = lib.optionalAttrs (cfg.disk.filesystem == "btrfs")
                      (lib.mapAttrs'
                        (name: value:
                          lib.nameValuePair "@${name}" {
                            mountpoint = name;
                            mountOptions =
                              (value.options or [ ])
                              ++ lib.optionals (value ? compression) [ "compress=${value.compression}" ];
                          })
                        cfg.btrfs.subvolumes);
                  };
            };
          };
        };
      };
    };

    # Add tmpfs for /tmp (if enabled in install-config.nix)
    nodev = lib.optionalAttrs cfg.tmpfs.enable {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=${cfg.tmpfs.size}"
          "mode=${cfg.tmpfs.mode}"
        ];
      };
    };
  };
}
