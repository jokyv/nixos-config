{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      editor = {
        auto-save = true;
        bufferline = "multiple";
        color-modes = true;
        cursorline = true;
        idle-timeout = 25;
        mouse = false;
        popup-border = "all";
        rulers = [ 120 ];
        scrolloff = 10;
        true-color = true;
        end-of-line-diagnostics = "hint";
        # inline-diagnostics.cursor-line = "error";
        inline-diagnostics.cursor-line = "warning";

        statusline = {
          left = [ "mode" "spinner" "diagnostics" ];
          center = [ "file-name" "read-only-indicator" "file-modification-indicator" ];
          right = [
            "version-control"
            "position"
            "position-percentage"
            "total-line-numbers"
            "file-type"
          ];
          separator = "│";

          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        file-picker.hidden = false;

        indent-guides = {
          render = true;
          rainbow-option = "normal";
          character = "┆";
          skip-levels = 1;
        };

        soft-wrap = {
          enable = true;
          wrap-indicator = "";
        };
      };

      keys = {
        insert = { };

        normal = {
          "esc" = [ "normal_mode" ":format" ":write" ];
          "H" = "extend_char_left";
          "J" = "extend_line_down";
          "K" = "extend_line_up";
          "L" = "extend_char_right";
          "W" = "extend_next_word_start";
          "B" = "extend_prev_word_start";
          "E" = "extend_next_word_end";
          "X" = "extend_line_above";
          "C" = [
            "move_next_word_end"
            "delete_selection"
            "insert_mode"
          ];
          "D" = [
            "extend_to_line_end"
            "yank_main_selection_to_clipboard"
            "delete_selection"
          ];
          "G" = "goto_file_end";
          "#" = "toggle_comments";
          "left" = "goto_previous_buffer";
          "right" = "goto_next_buffer";
          "{" = "goto_prev_paragraph";
          "}" = "goto_next_paragraph";
          "C-o" = ":config-open";
          "C-r" = [ ":w" ":config-reload" ];
          "C-v" = "paste_clipboard_before";
          "C-c" = "yank_to_clipboard";
          "C-j" = [ "extend_to_line_bounds" "delete_selection" "paste_after" ];
          "C-k" = [
            "extend_to_line_bounds"
            "delete_selection"
            "move_line_up"
            "paste_before"
          ];
          "C-a" = "switch_case";
          "tab" = "goto_next_function";
          "S-tab" = "goto_prev_function";
          "backspace" = [ "delete_char_backward" ];
        };

        normal.space.c = {
          # toggle zen mode
          "z" = ":toggle gutters.line-numbers.min-width 25 3";
          # toggle soft warp
          "s" = ":toggle soft-wrap.enable";
          "r" = [ ":w" ":config-reload" ];
          "o" = ":config-open";
          "w" = ":wq";
          "q" = ":q";
          "b" = ":bc";
        };
      };
    };

    languages = {
      language-server = {
        bash-language-server = {
          command = "bash-language-server";
          args = [ "start" ];
        };
        json-server = {
          command = "vscode-json-language-server";
        };
        markdown-oxide = {
          command = "markdown-oxide";
        };
        typos = {
          command = "typos-lsp";
          # config.typos =
          #   {
          #     diagnosticSeverity = "Hint"; # ["Error", "Warning", "Information", "Hint"]
          #     logLevel = "info"; # ["off", "error", "warn", "info", "debug", "trace"]
          #   };
        };
        nixd = {
          command = "nixd";
        };
        ruff = {
          command = "ruff";
          args = [ "server" "--preview" ];
        };
        pylsp = {
          command = "pylsp";
          config.pylsp.plugins = {
            pyls_mypy = {
              enabled = true;
              live_mode = true;
            };
          };
        };
        yaml-language-server = {
          command = "yaml-language-server";
          args = [ "--stdio" ];
        };
      };

      language = [
        {
          name = "bash";
          auto-format = true;
          scope = "source.bash";
          # file-types = [
          #   "sh"
          #   "bash"
          #   "text"
          #   "config"
          #   "ignore"
          #   ".conf"
          #   ".config"
          #   ".aliases"
          #   ".env"
          #   ".bashrc"
          #   ".bash_profile"
          #   ".exports"
          #   ".profile"
          # ];
          language-servers = [ "bash-language-server" ];
          formatter = {
            command = "shfmt";
            args = [ "-l" "-w" ];
          };
        }
        {
          name = "json";
          auto-format = true;
          file-types = [ "json" "kdl" ];
          language-servers = [ "json-server" ];
          formatter = {
            command = "dprint";
            args = [ "fmt" "--stdin" "json" ];
          };
        }
        {
          name = "markdown";
          comment-tokens = [ "-" "+" "*" "1." ">" "- [ ]" ];
          soft-wrap.enable = true;
          text-width = 80;
          soft-wrap.wrap-at-text-width = true;
          auto-format = true;
          # file-types = [ "md" ];
          # ltex-ls-plus uses https://languagetool.org/ under the hood.
          # language-servers = [ "marksman" "ltex-ls-plus"];
          language-servers = [ "markdown-oxide" "typos" ];
          formatter = {
            command = "dprint";
            args = [ "fmt" "--stdin" "md" ];
          };
        }
        {
          name = "nix";
          language-servers = [ "nixd" ];
          auto-format = true;
          formatter = {
            command = "nixpkgs-fmt";
          };
        }
        {
          name = "nu";
          auto-format = true;
          # language-servers = [ "nu-lsp" ]; # TODO: can not find it in nixos packages...
          formatter = { command = "nufmt"; args = [ "format" "--stdin" ]; };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [ "ruff" "pylsp" ];
          formatter = {
            command = "ruff";
            args = [ "format" "--quiet" "-" ];
          };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
        {
          name = "toml";
          auto-format = true;
          file-types = [ "toml" "ini" "pycodestyle" ];
          language-servers = [ "taplo" ];
          formatter = {
            command = "taplo";
            args = [ "fmt" "-" ];
          };
        }
        {
          name = "yaml";
          auto-format = true;
          file-types = [ "yaml" "yml" ];
          language-servers = [ "yaml-language-server" ];
          formatter = {
            command = "prettier";
            args = [ "--parser" "yaml" ];
          };
        }
      ];

      use-grammars = {
        only = [
          "bash"
          "json"
          "markdown"
          "nix"
          "nu"
          "python"
          "rust"
          "toml"
          "yaml"
        ];
      };

      # Auto-pairs for markdown and rust languages
      "language.auto-pairs" = {
        "(" = ")";
        "{" = "}";
        "[" = "]";
        "\"" = "\"";
        "<" = ">";
        "`" = "`";
        "*" = "*";
        "_" = "_";
      };
    };
  };
}
