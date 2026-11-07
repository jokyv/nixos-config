{
  lib,
  desktopSession ? "niri",
  ...
}:

{
  imports = [
    ../programs/bash.nix
    ../programs/foot.nix
    ../programs/kitty.nix
    ../programs/brave.nix
    ../programs/firefox.nix
    ../programs/wlsunset.nix
    ../programs/stylix.nix
    ../programs/effects.nix
    ../programs/starship.nix
    ../programs/git.nix
  ]
  ++ lib.optionals (desktopSession == "niri") [ ../programs/niri.nix ];
}
