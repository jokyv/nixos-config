{ config, pkgs, ... }:

let
  repoDir = "${config.home.homeDirectory}/nixos-config";
  prefetchHome = pkgs.writeShellScriptBin "prefetch-home-closure" ''
    exec ${pkgs.nix}/bin/nix build \
      --accept-flake-config \
      --extra-experimental-features "nix-command flakes" \
      --no-link \
      ${repoDir}#homeConfigurations.${config.home.username}.activationPackage
  '';
in
{
  systemd.user.services.prefetch-home-closure = {
    Unit = {
      Description = "Prefetch Home Manager closure";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${prefetchHome}/bin/prefetch-home-closure";
    };
  };

  systemd.user.timers.prefetch-home-closure = {
    Install = {
      WantedBy = [ "timers.target" ];
    };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "6h";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };

  systemd.user.paths.prefetch-home-closure = {
    Install = {
      WantedBy = [ "paths.target" ];
    };
    Unit = {
      Description = "Watch flake.lock for Home Manager prefetch";
    };
    Path = {
      PathChanged = "${repoDir}/flake.lock";
      Unit = "prefetch-home-closure.service";
    };
  };
}
