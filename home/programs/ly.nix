{ config, pkgs, ... }:

{
  services.ly = {
    enable = true;
    settings = {
      asterisk = "*";
      bg = "~/pics/wallpapers/space.png";
      blank_box = true;
      hide_borders = false;
      clock = "%H:%M:%S";
      date = "%a, %d %b";
      input_len = 34;
      lang = "en";
      min_refresh_delta = 5;
      waylandsessions = "${pkgs.niri}/share/wayland-sessions";
      shutdown_cmd = "${pkgs.systemd}/bin/systemctl poweroff";
      term_reset_cmd = "${pkgs.ncurses}/bin/tput reset";
      tty = 2;
    };
  };

  # Apply Stylix theming
  stylix.targets.ly = {
    enable = true;
    extraConfig = ''
      fg = "${config.stylix.colors.base05}"
      bg = "${config.stylix.colors.base00}"
      input_fg = "${config.stylix.colors.base05}"
      input_bg = "${config.stylix.colors.base01}"
      input_frame_fg = "${config.stylix.colors.base05}"
      frame = true
      margin_box_main_h = 2
      margin_box_main_v = 1
    '';
  };
}
