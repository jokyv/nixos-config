{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.ruff = {
    enable = true;
    settings = {
      # Maximum line length for code
      line-length = 120;

      format = {
        # Use spaces for indentation (default is tabs)
        indent-style = "space";
        # Automatically detect line ending style (LF/CRLF)
        line-ending = "auto";
        # Format code examples in docstrings
        docstring-code-format = true;
        # Maximum line length for docstring code blocks
        docstring-code-line-length = 88;
        # Keep magic trailing commas (helps with git diffs)
        skip-magic-trailing-comma = false;
      };

      lint = {
        # Allow ruff to auto-fix all enabled rules when using --fix
        fixable = [ "ALL" ];
        # No rules are explicitly marked as unfixable
        unfixable = [ ];

        # Enable specific rule sets for comprehensive linting
        select = [
          "A"    # flake8-builtins: Prevent shadowing Python built-ins
          "B"    # flake8-bugbear: Find likely bugs and design problems
          "C4"   # flake8-comprehensions: Improve list/set/dict comprehensions
          "D"    # pydocstyle: Docstring style checking
          "DTZ"  # flake8-datetimez: Proper datetime usage
          "E"    # pycodestyle errors: Code style errors
          "ERA"  # eradicate: Find commented-out code
          "F"    # Pyflakes: Detect various errors
          "I"    # isort: Import sorting
          "N"    # pep8-naming: Class and variable naming conventions
          "PERF" # Perflint: Performance anti-patterns
          "PIE"  # flake8-pie: Miscellaneous linting rules
          "PT"   # flake8-pytest-style: pytest-specific rules
          "Q"    # flake8-quotes: Quote consistency
          "RUF"  # Ruff-specific rules: Unused noqa and other Ruff rules
          "SIM"  # flake8-simplify: Code simplification suggestions
          "TCH"  # flake8-type-checking: Type checking blocks
          "TD"   # flake8-todos: TODO comment formatting
          "TID"  # flake8-tidy-imports: Import organization
          "UP"   # pyupgrade: Upgrade syntax to newer Python versions
          "W"    # pycodestyle warnings: Code style warnings
        ];

        # Disable specific rules that conflict with style preferences
        ignore = [
          "W191"        # Tab indentation (using spaces instead)
          "ERA001"      # Commented-out code (allow it)
          "E111"        # Indentation is not a multiple of 4
          "E114"        # Indentation level is not a multiple of 4 (comment)
          "E117"        # Over-indented

          # String concatenation style preferences
          "ISC001"      # Implicit string concatenation
          "ISC002"      # Multiple consecutive string literals

          # Docstring style exceptions (commonly disabled)
          "D100"        # Missing docstring in public module
          "D102"        # Missing docstring in public method
          "D103"        # Missing docstring in public function
          "D104"        # Missing docstring in public package
          "D105"        # Missing docstring in magic method
          "D107"        # Missing docstring in __init__

          # Alternative docstring style preferences
          "D203"        # One blank line before class docstring (Google style)
          "D212"        # Multi-line docstring summary starts at first line
          "D401"        # First line should be in imperative mood
          "D402"        # First line should not be the function's signature
          "D415"        # First line should end with period, question mark, or exclamation
          "D416"        # Section name ends with colon (Google style)

          # Tool-specific rule exceptions
          "PT011"       # pytest.raises() too broad
          "SIM102"      # Nested if statements (allow for clarity)
          "RUF005"      # Unnecessary direct calls to built-in functions (concatenation)

          # TODO comment flexibility
          "TD002"       # Missing author in TODO
          "TD003"       # Missing issue link in TODO
        ];

        # Docstring convention settings
        pydocstyle = {
          # Use numpy-style docstrings (recommended for scientific libraries)
          convention = "numpy";
        };

        # Quote style preferences
        flake8-quotes = {
          docstring-quotes = "double";    # Double quotes for docstrings
          inline-quotes = "double";       # Double quotes for inline strings
          multiline-quotes = "double";    # Double quotes for multiline strings
        };
      };
    };
  };
}