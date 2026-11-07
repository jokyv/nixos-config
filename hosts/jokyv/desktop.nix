{ pkgs, ... }:

{
  programs = {
    gamemode = {
      enable = true;
      settings = {
        gamemode = {
          start_reason = "GameMode activated";
          end_reason = "GameMode deactivated";
          enable_render_boost = true;
          enable_soft_realtime = true;
          io_rebalance_ioprio = true;
        };
      };
    };

    niri = {
      enable = true;
      package = pkgs.niri;
    };

    nix-ld.enable = true; # needs this for python uv
  };

  # Keep ReGreet and make GNOME available as an additional login session.
  services.desktopManager.gnome.enable = true;

  hardware.steam-hardware.enable = true;
}
