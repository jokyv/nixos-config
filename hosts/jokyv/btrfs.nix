{ ... }:

{
  # ---------------------------------------------
  # BTRFS Filesystem Settings
  # ---------------------------------------------
  # This assumes you are using BTRFS for your filesystems.
  # These settings help with maintaining the filesystem's health and performance.
  services.btrfs.automaticScrub = {
    enable = true;
    dates = "monthly";
    fileSystems = [ "/" ]; # This should be the mount point of your btrfs root.
  };
}
