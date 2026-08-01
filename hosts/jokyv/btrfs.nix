_:

{
  # ---------------------------------------------
  # BTRFS Filesystem Settings
  # ---------------------------------------------
  # This assumes you are using BTRFS for your filesystems.
  # These settings help with maintaining the filesystem's health and performance.

  fileSystems = {
    "/home/jokyv/.cache/fontconfig" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=256M"
        "mode=0755"
        "uid=1000"
        "gid=100"
      ];
    };

    "/home/jokyv/.cache/mesa_shader_cache" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=256M"
        "mode=0700"
        "uid=1000"
        "gid=100"
      ];
    };
  };

  # Enable automatic BTRFS scrubbing to detect and repair data corruption
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly"; # Scrub the filesystem once per month
    fileSystems = [ "/" ]; # Scrub the root filesystem
  };
}
