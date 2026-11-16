_: {
  programs.ty = {
    enable = true;

    settings = {
      # Target Python version
      python-version = "3.14";

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
