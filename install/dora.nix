{
  # Install config for dora machine
  disk = {
    device = null;
    filesystem = "btrfs";
    swapSize = null;
    efiSize = "512M";
    useLuks = false;
    encryptSwap = false;
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
    size = "2G";
    mode = "1777";
  };
}
