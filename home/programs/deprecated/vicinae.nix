# Vicinae - A feature-rich, fast launcher compatible with Raycast plugins
# Docs: https://docs.vicinae.com
# GitHub: https://github.com/vicinaehq/vicinae

{
  inputs,
  ...
}:
{
  # Import the Vicinae home-manager module
  # Make sure to add vicinae to your flake inputs:
  # inputs.vicinae.url = "github:vicinaehq/vicinae";
  # imports = [
  #   inputs.vicinae.homeManagerModules.default
  # ];

  services.vicinae = {
    enable = true;
    systemd.autoStart = true;
    settings = {
      faviconService = "twenty"; # twenty | google | none
      font.size = 11;
      popToRootOnClose = false;
      rootSearch.searchFiles = false;
      # theme.name = "vicinae-dark"; # managed by stylix
      window = {
        csd = true;
        # opacity = 0.95;
        rounding = 10;
      };
    };
  };
}
