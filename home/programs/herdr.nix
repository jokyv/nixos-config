{
  config,
  inputs,
  pkgs,
  ...
}:

{
  home.packages = [
    inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."herdr-app/settings.json".text = builtins.toJSON {
    zoom = 1.2;
    sounds.enabled = false;
    font = config.stylix.fonts.monospace.name;
    font_size = 16.0;
    minimum_contrast = 1.0;
  };

  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [server]
    headless_cols = 160
    headless_rows = 50

    [terminal]
    new_cwd = "follow"


    [ui]
    sidebar_width = 30
    sidebar_min_width = 20
    sidebar_max_width = 42
    agent_panel_sort = "priority"
    status_indicators = "symbols"
    show_agent_labels_on_pane_borders = true
    hide_tab_bar_when_single_tab = true
    window_title = "{hostname}: {workspace}"

    [session]
    resume_agents_on_restore = true
    [worktrees]
    directory = "~/.local/share/herdr/worktrees"

    [ui.toast]
    delivery = "system"
    delay_seconds = 1

    [ui.sound]
    enabled = false
  '';
}
