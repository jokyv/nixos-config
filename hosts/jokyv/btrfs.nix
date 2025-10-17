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

  # Set up BTRFS quotas for subvolumes
  systemd.services.btrfs-quota-setup = {
    description = "Set up BTRFS quotas";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # Enable quota support for the filesystem
      if btrfs quota enable /; then
        echo "Quota support enabled"
        
        # Find the subvolume ID for /var
        VAR_ID=$(btrfs subvolume list / | grep "@var" | awk '{print $2}')
        if [ -n "$VAR_ID" ]; then
          # Create a qgroup for the subvolume if it doesn't exist
          btrfs qgroup create "0/$VAR_ID" / || true
          
          # Set the quota limit (20GB)
          if btrfs qgroup limit 20G "0/$VAR_ID" /; then
            echo "Quota set for /var subvolume (ID: $VAR_ID)"
          else
            echo "Failed to set quota for /var subvolume"
          fi
        else
          echo "Could not find /var subvolume ID"
        fi
      else
        echo "Failed to enable quota support"
      fi
    '';
  };
}
