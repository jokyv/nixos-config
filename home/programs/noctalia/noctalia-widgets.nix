{ config, lib, pkgs, ... }:

with lib;

let
  # Plugin ID from manifest (must match manifest.json)
  pluginId = "io.github.jokyv.noctilia.clock";

  noctaliaWidgetsPkg = pkgs.stdenv.mkDerivation {
    name = "noctalia-widgets";
    src = ./noctalia-widgets;  # Widget files directory
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      mkdir -p $out/share/noctalia/plugins/${pluginId}
      cp -r $src/* $out/share/noctalia/plugins/${pluginId}/
    '';
  };
in {
  # Install the widget package and set plugin path
  home.packages = [ noctaliaWidgetsPkg ];

  home.sessionVariables = {
    NOCTALIA_PLUGINS_PATH = "${noctaliaWidgetsPkg}/share/noctalia/plugins:${config.xdg.dataHome}/noctalia/plugins";
  };
}
