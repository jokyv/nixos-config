{ ... }:

{

  # Enable fastfetch and configure its options
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "arch_large";
        padding = {
          right = 1;
        };
      };
      # display = {
      #   size = {
      #     binaryPrefix = "si";
      #   };
      #   color = "blue";
      #   separator = "  ";
      # };
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
        "cpu"
        "memory"
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

