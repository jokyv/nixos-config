{ lib, pkgs, ... }:

let
  # Import the install-config
  installConfig = import ../install-config.nix;

  # Use the config directly (single-host setup)
  cfg = installConfig;

  # Simple approach using diskseq for the first disk
  # This is more reliable than scanning /sys/block during evaluation
  device = "/dev/disk/by-diskseq/1";

  # Validate that we can find at least one disk
  # Note: This validation happens at evaluation time during installation
  disksAvailable = builtins.pathExists "/dev/disk/by-diskseq";

  # Build an error message if no disks are found
  diskCheck =
    if !disksAvailable then
      throw ''
        ERROR: No disks found in the system!

        Please ensure:
        1. You're running this on actual hardware (not in a container)
        2. Disks are properly connected and detected by the system
        3. You have permission to access /dev/disk/by-diskseq/

        To check available disks, run: lsblk

        If you need to select a specific disk, edit disks/universal-config.nix
        and change the 'device' line to point to your disk (e.g., "/dev/sda" or "/dev/nvme0n1")
      ''
    else
      # If disks are available, verify the first one exists
      let
        firstDiskExists = builtins.pathExists device;
      in
        if !firstDiskExists then
          throw ''
            ERROR: No disk found at ${device}!

            This might happen if:
            - The system has no disks
            - Disk detection is delayed (try again)
            - The system uses a different disk naming scheme

            Available disks:
            ${pkgs.lib.concatMapStringsSep "\n" (d: "  - ${d}")
              (lib.splitString "\n" (builtins.readFile "/proc/partitions"))}

            To use a specific disk, edit disks/universal-config.nix and change:
            device = "${device}";
            To your actual disk path.
          ''
        else
          device;

in {
  disko.devices = {
    disk = {
      main = {
        # Use the validated disk (or throw error if not found)
        device = diskCheck;
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
                if cfg.disk.useLuks then {
                  type = "luks";
                  name = cfg.disk.luks.name;
                  content = {
                    type = cfg.disk.filesystem;
                    extraArgs = lib.optionals (cfg.disk.filesystem == "btrfs") [
                      "-L" cfg.btrfs.filesystemLabel
                    ];
                    subvolumes = lib.optionalAttrs (cfg.disk.filesystem == "btrfs") cfg.btrfs.subvolumes;
                  };
                } else {
                  type = cfg.disk.filesystem;
                  extraArgs = lib.optionals (cfg.disk.filesystem == "btrfs") [
                    "-L" cfg.btrfs.filesystemLabel
                  ] ++ lib.optionals (cfg.disk.filesystem == "ext4") [
                    "-L" cfg.ext4.filesystemLabel
                  ];
                  subvolumes = lib.optionalAttrs (cfg.disk.filesystem == "btrfs") cfg.btrfs.subvolumes;
                };
            };
          };
        };
      };
    };

    # Add tmpfs for /tmp
    filesystems."/tmp" = {
      type = "tmpfs";
      mountpoint = "/tmp";
      options = [
        "defaults"
        "size=4G"
        "mode=1777"
      ];
    };
  };
}