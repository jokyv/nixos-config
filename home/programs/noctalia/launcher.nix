{ config, pkgs, lib, ... }:

{
  programs.noctalia.settings = {
    shell = {
      clipboard_enabled = true;
      clipboard_auto_paste = "auto";
      clipboard_confirm_clear_history = true;
      clipboard_history_max_entries = 100;

      panel = {
        launcher_placement = "centered";
        launcher_categories = true;
        launcher_show_icons = true;
        launcher_compact = false;
        launcher_session_search = false;
        clipboard_placement = "centered";
        transparency_mode = "solid";
        shadow = true;
        borders = true;
      };
    };
  };
}