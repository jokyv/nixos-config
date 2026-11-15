{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../programs/git.nix
    ../programs/helix.nix
    ../programs/fd.nix
    ../programs/ripgrep.nix
    ../programs/fzf.nix
    ../programs/zoxide.nix
    ../programs/starship.nix
  ];

  config =
    lib.mkIf
      (pkgs.stdenv.hostPlatform.isLinux && config.programs.foot.enable && config.programs.firefox.enable)
      {
        xdg.desktopEntries.helix-foot = {
          name = "Helix";
          exec = "${pkgs.foot}/bin/foot ${config.programs.helix.package}/bin/hx %F";
          icon = "helix";
          type = "Application";
        };

        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "text/*" = "helix-foot.desktop";
            "text/html" = "firefox.desktop";
            "application/xhtml+xml" = "firefox.desktop";
            "application/x-extension-htm" = "firefox.desktop";
            "application/x-extension-html" = "firefox.desktop";
            "application/x-extension-shtml" = "firefox.desktop";
            "application/x-extension-xhtml" = "firefox.desktop";
            "application/x-extension-xht" = "firefox.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
            "x-scheme-handler/chrome" = "firefox.desktop";
            "x-scheme-handler/mailto" = "userapp-Evolution-VT5LW3.desktop";
          };
          associations.added = {
            "text/*" = "helix-foot.desktop";
            "text/html" = [
              "firefox.desktop"
              "org.gnome.Epiphany.desktop"
            ];
            "application/xhtml+xml" = [
              "firefox.desktop"
              "org.gnome.Epiphany.desktop"
            ];
            "application/x-extension-htm" = "firefox.desktop";
            "application/x-extension-html" = "firefox.desktop";
            "application/x-extension-shtml" = "firefox.desktop";
            "application/x-extension-xhtml" = "firefox.desktop";
            "application/x-extension-xht" = "firefox.desktop";
            "x-scheme-handler/http" = [
              "firefox.desktop"
              "org.gnome.Epiphany.desktop"
            ];
            "x-scheme-handler/https" = [
              "firefox.desktop"
              "org.gnome.Epiphany.desktop"
            ];
            "x-scheme-handler/chrome" = "firefox.desktop";
            "x-scheme-handler/mailto" = "userapp-Evolution-VT5LW3.desktop";
          };
        };

      };
}
