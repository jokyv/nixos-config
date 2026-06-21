{ lib, ... }:

{
  home.sessionVariables = {
    OBSIDIAN_USE_WAYLAND = "1";
    DISCORD_USE_WAYLAND = "1";
  };

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "obsidian"
        "discord"
        "keymapp"
        "claude-code"
      ];
  };
}
