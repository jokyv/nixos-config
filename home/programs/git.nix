{ config, pkgs, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "John Kyvetos";
        email = "johnkyvetos@gmail.com";
      };
    };

    ignores = [
      # macOS
      ".DS_Store"
      "**/.DS_Store"

      # Python
      "**pycache**"
      "**/__pycache__/**"
      "*/thumbs.db"
      "*/.vscode"
      "**/.venv"

      # Development Caches
      ".ruff_cache"
      "/.mypy_cache/"

      # LVim settings
      "**/plugin/*"
      "**/spell/en.utf-8.add.spl"

      # Rust/Cargo
      "**/debug/*"
      "**/target/*"
      "**/Cargo.lock"
      "**/*.rs.bk"
      "*.pdb"

      # Lua
      "luac.out"
      "*.src.rock"

      # Compressed Files
      "*.zip"
      "*.tar.gz"

      # Object and Compiled Files
      "*.o"
      "*.os"
      "*.ko"
      "*.obj"
      "*.elf"

      # Precompiled Headers
      "*.gch"
      "*.pch"

      # Libraries
      "*.lib"
      "*.a"
      "*.la"
      "*.lo"
      "*.def"
      "*.exp"

      # Shared Objects
      "*.dll"
      "*.so"
      "*.so.*"
      "*.dylib"

      # Executables
      "*.exe"
      "*.out"
      "*.app"
      "*.i*86"
      "*.x86_64"
      "*.hex"
    ];

    # Core settings
    settings = {
      alias = {
        ignore = "!gi() { local IFS=','; curl -sL \"https://www.toptal.com/developers/gitignore/api/\\$*\"; }; gi";
        l = "!f() { count=$1; if [ -z \"$count\" ]; then count=5; fi; git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n \"$count\"; }; f";
        graph = "!f() { count=$1; if [ -z \"$count\" ]; then count=5; fi; git log --all --graph --decorate --oneline -n \"$count\"; }; f";
      };
      init = {
        defaultBranch = "main";
      };

      pull = {
        rebase = true;
      };

      core = {
        editor = "hx";
        pager = "cat";
      };

      color = {
        ui = "auto";
      };

      credential = {
        helper = "store";
      };

      interactive = {
        diffFilter = "delta --color-only";
      };

      add.interactive = {
        useBuiltin = false;
      };

      delta = {
        features = "side-by-side line-numbers decorations";
        navigate = true;
        "plus-style" = "syntax \"#003800\"";
        "minus-style" = "syntax \"#3f0001\"";
      };

      "delta \"decorations\"" = {
        "commit-decoration-style" = "bold yellow box ul";
        "file-style" = "bold yellow ul";
        "file-decoration-style" = "none";
        "hunk-header-decoration-style" = "cyan box ul";
      };

      "delta \"line-numbers\"" = {
        "line-numbers-left-style" = "cyan";
        "line-numbers-right-style" = "cyan";
        "line-numbers-minus-style" = "124";
        "line-numbers-plus-style" = "28";
      };

      merge = {
        conflictstyle = "diff3";
      };

      diff = {
        colorMoved = "default";
      };

    };
  };
}
