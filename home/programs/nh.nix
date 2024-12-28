{ config, pkgs, ... }:

{
  programs.nh = {
    enable = true;
    # flake = "${config.home.homeDirectory}/nixos-config";
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
      dates = "weekly";
    };
  };
}
