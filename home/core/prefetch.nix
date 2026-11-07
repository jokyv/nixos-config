{
  config,
  pkgs,
  desktopSession ? "niri",
  ...
}:

let
  repoDir = "${config.home.homeDirectory}/nixos-config";
  homeOutput =
    if desktopSession == "niri" then
      config.home.username
    else
      ''\"${config.home.username}@nixos-gnome-development\"'';
  prefetchHome = pkgs.writeShellScriptBin "prefetch-home-closure" ''
    ${pkgs.coreutils}/bin/mkdir -p "${config.home.homeDirectory}/.cache"
    exec ${pkgs.util-linux}/bin/flock "${config.home.homeDirectory}/.cache/nix-prefetch.lock" \
      ${pkgs.nix}/bin/nix build \
      --max-jobs 1 --cores 4 \
      --accept-flake-config \
      --extra-experimental-features "nix-command flakes" \
      --no-link \
      ${repoDir}#homeConfigurations.${homeOutput}.activationPackage
  '';
in
{
  systemd.user = {
    services.prefetch-home-closure = {
      Unit = {
        Description = "Prefetch Home Manager closure";
        OnFailure = [ "prefetch-home-closure-failed.service" ];
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${prefetchHome}/bin/prefetch-home-closure";
      };
    };

    services.prefetch-home-closure-failed = {
      Unit.Description = "Notify about Home Manager prefetch failure";
      Service = {
        Type = "oneshot";
        ExecStart = ''${pkgs.libnotify}/bin/notify-send --urgency=critical "Home Manager prefetch failed" "Check: journalctl --user -u prefetch-home-closure.service"'';
      };
    };

    timers.prefetch-home-closure = {
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

    paths.prefetch-home-closure = {
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
  };
}
