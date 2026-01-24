{ inputs, pkgs, ... }:

let
  userHome = builtins.getEnv "HOME";
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
        "https://vicinae.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      ];
    };

    # Enable nix-direnv for development environments
    package = pkgs.nixVersions.stable;
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
