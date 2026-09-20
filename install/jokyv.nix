{
  # Install config for jokyv machine
  disk = {
    device = "/dev/disk/by-id/nvme-eui.0025385691b5a680";
    filesystem = "btrfs";
    swapSize = "32G";
    efiSize = "512M";
    useLuks = false;
    encryptSwap = true;
    luks = {
      name = "encrypted";
    };
  };

  btrfs = {
    filesystemLabel = "nixos";
    subvolumes = {
      "/" = {
        options = [
          "compress-force=zstd:3"
          "noatime"
          "ssd"
          "discard=async"
        ];
      };
      "/home" = {
        options = [
          "compress=zstd"
          "noatime"
        ];
      };
      "/nix" = {
        options = [
          "noatime"
          "compress-force=zstd:1"
          "nodatacow"
        ];
      };
      "/var" = {
        options = [
          "compress=zstd"
          "noatime"
        ];
      };
    };
  };

  ext4 = {
    filesystemLabel = "nixos";
    mountOptions = [ "noatime" ];
  };

  tmpfs = {
    enable = true;
    size = "4G";
    mode = "1777";
  };
}
