{ config, lib, pkgs, ... }:

with lib;

let
  # Plugin ID from manifest (must match manifest.json)
  pluginId = "io.github.jokyv.noctilia.clock";

  noctiliaWidgetsPkg = pkgs.stdenv.mkDerivation {
    name = "noctilia-widgets";
    src = ./noctilia-widgets;  # Only the widget files directory
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      mkdir -p $out/share/noctilia/plugins/${pluginId}
      cp -r $src/* $out/share/noctilia/plugins/${pluginId}/
    '';
  };
in {
  # Option to enable Noctilia desktop widgets
  options.programs.noctilia-widgets = {
    enable = mkEnableOption "Noctilia desktop widget plugins";
    package = mkOption {
      type = types.package;
      default = noctiliaWidgetsPkg;
      description = "Noctilia widgets package to install";
    };
  };

  # Install the widgets and configure Noctilia
  config = lib.mkIf config.programs.noctilia-widgets.enable {
    # Install the widget plugin
    home.packages = [ config.programs.noctilia-widgets.package ];

    # Set NOCTILIA_PLUGINS_PATH environment variable so Noctilia can find the plugins
    home.sessionVariables = {
      NOCTILIA_PLUGINS_PATH = "${config.programs.noctilia-widgets.package}/share/noctilia/plugins:${config.xdg.dataHome}/noctilia/plugins";
    };
  };
}
