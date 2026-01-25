{ ... }:
{
  programs.ty = {
    enable = true;

    settings = {
      # Target Python version
      python-version = "3.13";

      # Common exclusions
      exclude = [
        "build/*"
        "dist/*"
        "migrations/*"
        ".venv/*"
        "venv/*"
      ];

      # Rule configurations
      rules = {
        "index-out-of-bounds" = "error";
        "assert-always-fails" = "warn";
      };
    };
  };
}
