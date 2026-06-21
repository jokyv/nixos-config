{
  # Install config for jokyv machine
  disk = {
    device = "/dev/nvme0n1";
    filesystem = "btrfs";
    swapSize = "32G";
    efiSize = "512M";
    useLuks = false;
    encryptSwap = true;
    luks = {
      name = "crypted";
    };
  };

  btrfs = {
    filesystemLabel = "nixos";
    subvolumes = {
      "/" = {
        options = [
          "compress=zstd"
          "noatime"
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
          "compress=zstd:1"
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
