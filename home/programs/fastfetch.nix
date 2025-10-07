{ pkgs, ... }:

{
  # Add jaq for the weather module dependency.
  home.packages = [ pkgs.jaq ];

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding.right = 1;
      };

      # General display settings
      display = {
        # Use SI prefixes (kB, MB, GB) instead of binary (KiB, MiB, GiB)
        binaryPrefix = "si";
        # A custom separator between the key and value.
        separator = " > ";
      };

      modules = [
        {
          type = "datetime";
          key = "Date";
          format = "{1}-{3}-{11}";
        }
        {
          type = "datetime";
          key = "Time";
          format = "{14}:{17}:{20}";
        }
        "title"
        "uptime"
        "separator"
        "os"
        "host"
        "kernel"
        "packages"
        "shell"
        "de"
        "wm"
        "wmtheme"
        "theme"
        "icons"
        "font"
        "terminal"
        "terminalfont"
        "separator"
        {
          type = "cpu";
          key = "CPU";
          # Format: <name> (<usage>)
          format = "{1} ({5}%)";
        }
        "gpu" # Shows GPU name, driver, temperature, etc.
        {
          type = "memory";
          # Format: <used> / <total> (<percentage_used>)
          format = "{/1} / {/2} ({/3}%)";
        }
        "disk"
        "separator"
        "network"
        "localip"
        "publicip"
        "break"
        "colors"
      ];
    };
  };
}

