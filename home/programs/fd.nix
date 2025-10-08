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

    extraOptions = [
      "--hidden" # Include hidden files in searches (useful with ignore rules)
      "--color=always" # Enable colorized output
      "--follow" # Follow symbolic links
      "--exec-batch" # Allow batch execution of commands on found files
    ];
  };
}
