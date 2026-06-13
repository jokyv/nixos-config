{ config, pkgs, lib, ... }:

{
  programs.noctalia.settings = {
    desktop_widgets = {
      enabled = true;
      schema_version = 2;

      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };
    };
  };
}