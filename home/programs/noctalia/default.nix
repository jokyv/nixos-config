{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./bar.nix
    ./widgets.nix
    ./notifications.nix
    ./ui.nix
    ./idle.nix
    ./launcher.nix
    ./dock.nix
    ./wallpaper.nix
    ./desktop-widgets.nix
    ./resume-fix.nix
  ];

  programs.noctalia.enable = true;
  programs.noctalia.package =
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (old: {
        # RAM bar label only: keep binary GiB calculation, abbreviate its suffix.
        postPatch = (old.postPatch or "") + ''
          substituteInPlace src/shell/bar/widgets/sysmon_widget.cpp \
            --replace-fail 'return FormatUnits::formatBinaryMib(stats.ramUsedMb);' \
            'return std::format("{:.1F} G", static_cast<double>(stats.ramUsedMb) / 1024.0);'
          substituteInPlace src/shell/bar/widgets/lock_keys_widget.cpp \
            --replace-fail 'lockState.capsLock ? colorSpecFromRole(ColorRole::Primary)' \
            'lockState.capsLock ? colorSpecFromRole(ColorRole::OnSurface)'
        '';
      });

  xdg.desktopEntries.noctalia-annotate = {
    name = "Annotate with Noctalia";
    comment = "Draw on an image and save an annotated copy";
    exec = "${config.programs.noctalia.package}/bin/noctalia msg annotate %f";
    icon = "image-x-generic";
    terminal = false;
    noDisplay = true;
    mimeType = [
      "image/png"
      "image/jpeg"
      "image/webp"
      "image/bmp"
      "image/tiff"
    ];
    categories = [ "Graphics" ];
  };
}
