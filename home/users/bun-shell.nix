{
  config,
  lib,
  pkgs,
  ...
}:

let
  bunPath = ''
    case ":$PATH:" in
      *":$HOME/.bun/bin:"*) ;;
      *) export PATH="$HOME/.bun/bin:$PATH" ;;
    esac
    export BUN_INSTALL="''${BUN_INSTALL:-$HOME/.bun}"
  '';
in
{
  home.sessionVariables.BUN_INSTALL = "${config.home.homeDirectory}/.bun";
  home.sessionPath = [ "${config.home.homeDirectory}/.bun/bin" ];

  programs.bash = {
    enable = true;
    package = null;
    enableCompletion = false;
    # macOS system Bash 3.2 lacks globstar and checkjobs.
    shellOptions = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin [
      "histappend"
      "extglob"
    ];
    initExtra = bunPath;
    profileExtra = bunPath;
  };
}
