{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.herdr.packages.${pkgs.system}.default
  ];

  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [server]
    headless_cols = 160
    headless_rows = 50

    [terminal]
    new_cwd = "follow"

    [worktrees]
    directory = "~/.local/share/herdr/worktrees"

    [ui.toast]
    delivery = "system"
    delay_seconds = 1

    [ui.sound]
    enabled = false
  '';
}
