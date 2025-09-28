{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    profileExtra = ''

      # function that will source a file if it exists
      function source_if_exists {
          if test -r "$1"; then source "$1"
          fi
      }

      # source bashrc if exist
      source_if_exists $HOME/.bashrc

      # Print if the file is sourced
      echo "-- .bash_profile file sourced"

    '';

    shellAliases = {

      # Easier Navigation
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      ".2" = "cd ../../";
      ".3" = "cd ../../../";
      ".4" = "cd ../../../../";
      "c" = "clear";
      "ssd" = "sudo shutdown now";
      "sr" = "sudo reboot";

      # File Operations
      "mkdir" = "mkdir -pv";
      "rm" = "rm -iv";
      "mv" = "mv -iv";
      "cp" = "cp -iv";
      "ln" = "ln -i";
      # "cat" = "bat --paging=never";
      "b" = "bash";
      "e" = "exit";
      "ep" = "echo $PATH | tr : \"\\n\"";
      "cleanup" = "find . -type f -name '*.DS_Store' -ls -delete";

      # Linux Scripts
      "sb" = "source_files";
      "cdd" = "cd_with_eza";

      # FZF Scripts
      "vv" = "fzf_util.py --open_file";
      "fe" = "fzf_util.py --empty_files";
      "fb" = "fzf_util.py --big_files";
      "fs" = "fzf_util.py --find_scripts";
      "fm" = "fzf_util.py --move_file";
      "fc" = "fzf_util.py --copy_file";
      "ff" = "fzf_util.py --file_phrase";

      # Python
      "p3" = "python3";
      "p" = "python_execute_script.py";
      "pipv" = "uv pip list | fzf";
      "pu" = "python_pip_update.py -S";
      "pua" = "python_pip_update.py -A";
      "pic" = "python_init_code.py";
      "a" = "source ~/uv_default/bin/activate";
      "talk" = "source ~/talk_to_ai/bin/activate";
      "d" = "deactivate";

      # Rust/Cargo
      "cn" = "cargo new";
      "ci" = "cargo install";
      "cc" = "cargo check";
      "cr" = "cargo run";
      "cb" = "cargo build";
      "cs" = "cargo search";
      "ct" = "cargo test";
      "cu" = "cargo install-update -a";
      "cl" = "cargo install-update -l";

      # eza
      "l" = "eza --color=always --icons=always --long --all --group-directories-first --git --no-permissions --no-filesize --no-time --no-user";
      "ll" = "eza --color=always --icons=always --long --all --group-directories-first --git";
      "lls" = "eza --color=always --icons=always --long --all --group-directories-first --total-size --sort=size --reverse";
      "lll" = "eza --color=always --icons=always --long -all";

      # Trash
      "rmd" = "trash";
      "trl" = "trash list";
      "tra" = "trash empty --all";
      "trr" = "fzf_util.py --restore_file";
      "tre" = "fzf_util.py --empty_trash";

      # Git
      "ginit" = "git_util.py --init_template";
      "gpu" = "git push";
      "gpl" = "git pull";
      "ga" = "git add";
      "gall" = "git add -A";
      "gc" = "git commit";
      "gcm" = "git commit -m";
      "gcw" = "git_util.py --commit_workflow";
      "gl" = "git log";
      "glo" = "git log --oneline";
      "glg" = "git_util.py --log_graph";
      "gpulla" = "git_util.py --pull_all_dirs";
      "gpusha" = "git_util.py --push_all_dirs";
      "gac" = "git_util.py --auto_commit";
      "gcame" = "git commit --amend --no-edit";
      "gcheck" = "git checkout .";
      "gs" = "git status -sb";
      "gsa" = "git_util.py --status_all_dirs";
      "gclean" = "git_util.py --clean_up";
      "gd" = "git diff -w";
      "gh-create" = "git_util.py --create_push_gh_repo";

    };

    # Functions need to go in initExtra
    initExtra = ''

      # Set shell options
      set -o vi
      shopt -s cdspell
      bind 'set completion-ignore-case on'
      complete -d cd

      # FZF z function
      z() {
          local dir
          dir=$(fzf_go_to_path.sh)
          if [ -n "$dir" ]; then
              cd "$dir" && eza --color=always --icons=always --long --all --group-directories-first --git
          else
              echo "No directory selected."
          fi
      }

      # Yazi function
      yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      # Function to add directories to $PATH if they aren't already included
      function add_to_path {
        case ":$PATH:" in
          *":$1:"*) :;; # already there
          *) PATH="$1:$PATH";; # or PATH="$PATH:$1"
        esac
      }

      # Function to source files if they exist
      function source_if_exists {
        if test -r "$1"; then source "$1"; fi
      }

      # Uncomment if you're using Cargo (Rust) binaries
      # add_to_path $HOME/.local/share/cargo/bin

      # Source personal scripts
      add_to_path $HOME/scripts/bin/
      
      # Source additional scripts, aliases, and exports
      source_if_exists $HOME/nixos-config/bin/linux_scripts.sh

      # Initialize external programs and utilities
      eval "$(starship init bash)"
      source_if_exists $HOME/.bash-preexec.sh
      eval "$(atuin init bash)"
      eval "$(uv generate-shell-completion bash)"
      eval "$(zoxide init bash)"

      # Set NIX_PATH environment variable
      export NIX_PATH=nixpkgs=https://github.com/nixos/nixpkgs/archive/refs/heads/master.tar.gz

      # SOPS
      export SOPS_AGE_KEY_FILE=~/.config/sops/age/secrets.key

      # Print sourced confirmation
      echo "-- aliases loaded"

    '';

    # If you want to add more PATH modifications, you can use
    bashrcExtra = '''';
  };

}
