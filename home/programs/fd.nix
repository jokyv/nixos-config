{ config, pkgs, ... }:

{
  programs.fd = {
    enable = true;
    ignores = [
      "**/.local/share/*"
      "**/.cache/*"
      "**/.mypy_cache/*"
      "**/.git/*"
      "**/*.parquet"
    ];


    # Set additional options for fd
    extraOptions = [
      "--hidden" # Include hidden files in searches (useful with ignore rules)
      "--color=always" # Enable colorized output
      "--follow" # Follow symbolic links
    ];

    # Add fd to the PATH
    # inherit (pkgs) fd;
  };
}





