{ ... }:

{
  # ---------------------------------------------
  # BTRFS Filesystem Settings
  # ---------------------------------------------
  # This assumes you are using BTRFS for your filesystems.
  # These settings help with maintaining the filesystem's health and performance.
  
  # Enable automatic BTRFS scrubbing to detect and repair data corruption
  services.btrfs.automaticScrub = {
    enable = true;
    interval = "monthly";  # Scrub the filesystem once per month
    fileSystems = [ "/" ]; # Scrub the root filesystem
  };

  # BTRFS quota setup - disabled for now due to complexity
  # Setting up quotas properly requires more sophisticated handling
  # and might be better done manually or through a more robust service
  /*
  systemd.services.btrfs-quota-setup = {
    description = "Set up BTRFS quotas";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Wait for filesystem to be fully mounted and ready
      sleep 5
      
      # Enable quota support for the filesystem
      if btrfs quota enable /; then
        echo "Quota support enabled"
        
        # Find the subvolume ID for /var (looking for the actual mount point)
        VAR_ID=$(btrfs subvolume list / | grep -w "/var" | awk '{print $2}')
        if [ -n "$VAR_ID" ]; then
          echo "Found /var subvolume with ID: $VAR_ID"
          # Set the quota limit (20GB)
          if btrfs qgroup limit 20G "0/$VAR_ID" /; then
            echo "Quota set for /var subvolume"
          else
            echo "Failed to set quota for /var subvolume"
          fi
        else
          echo "Could not find /var subvolume"
        fi
      else
        echo "Failed to enable quota support (might already be enabled)"
      fi
    '';
  };
  */
}
