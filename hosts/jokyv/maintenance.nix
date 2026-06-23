{ config, inputs, pkgs, primaryUser ? "jokyv", ... }:

let
  repoDir = "/home/${primaryUser}/nixos-config";
  prefetchSystem = pkgs.writeShellScriptBin "prefetch-system-closure" ''
    exec ${pkgs.nixVersions.stable}/bin/nix build \
      --accept-flake-config \
      --extra-experimental-features "nix-command flakes" \
      --no-link \
      ${repoDir}#nixosConfigurations.${config.networking.hostName}.config.system.build.toplevel
  '';
in
{
  # ---------------------------------------------
  # System Automation
  # ---------------------------------------------

  # check by running 'systemctl list-timers'

  nix = {
    # auto optimisation
    optimise = {
      automatic = true;
      dates = "Sun 11:00";
      persistent = true;
      randomizedDelaySec = "45min";
    };

    # Garbage Collection
    gc = {
      automatic = true;
      dates = "Sun 11:00";
      options = "--delete-older-than 7d";
      persistent = true;
      randomizedDelaySec = "45min";
    };

    # Nix Configuration
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "jokyv"
      ];
      warn-dirty = false;

      # Binary caches for faster builds
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://noctalia.cachix.org"
        # "https://vicinae.cachix.org"  # disabled - using noctalia
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        # "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="  # disabled - using noctalia
      ];
    };

    # Enable nix-direnv for development environments
    package = pkgs.nixVersions.stable;
  };

  systemd.services.prefetch-system-closure = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${prefetchSystem}/bin/prefetch-system-closure";
    };
  };

  systemd.timers.prefetch-system-closure = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "6h";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };

  systemd.paths.prefetch-system-closure = {
    wantedBy = [ "paths.target" ];
    pathConfig = {
      PathChanged = "${repoDir}/flake.lock";
      Unit = "prefetch-system-closure.service";
    };
  };

  # Automatic system updates
  system.autoUpgrade = {
    enable = true;
    dates = "Sat 11:00";
    allowReboot = false;
    flake = inputs.self.outPath;
    flags = [
      "--update"
      "nixpkgs"
      "-L"
      "--commit-lock-file"
    ];
    randomizedDelaySec = "45min";
    persistent = true;
  };
}
