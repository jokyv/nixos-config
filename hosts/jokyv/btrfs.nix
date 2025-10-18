{ ... }:

{
  # ---------------------------------------------
  # BTRFS Filesystem Settings
  # ---------------------------------------------
  # This assumes you are using BTRFS for your filesystems.
  # These settings help with maintaining the filesystem's health and performance.

  # Enable automatic BTRFS scrubbing to detect and repair data corruption
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly"; # Scrub the filesystem once per month
    fileSystems = [ "/" ]; # Scrub the root filesystem
  };
}
