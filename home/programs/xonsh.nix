{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Xonsh shell with additional packages
    (python3.withPackages (ps: with ps; [
      xonsh
      polars # Data manipulation library
      prompt-toolkit
      pygments
    ]))

    # Additional shell-related tools
    zoxide # Smarter cd command
    starship # Customizable prompt
    atuin # Shell history management
  ];


  # Optional: Xonsh configuration
  home.file.".config/xonsh/rc.xonsh".text = ''
    # Enable zoxide integration
    execx($(zoxide init xonsh))

    # Atuin shell history
    execx($(atuin init xonsh))

    # Additional Xonsh customizations
    $PROMPT = '{BOLD_GREEN}{user}@{hostname} {BOLD_BLUE}{cwd}{RESET} {BOLD_RED}→{RESET} '
  '';
}
