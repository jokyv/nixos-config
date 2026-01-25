{ config, pkgs, ... }:

{
  home.sessionVariables = {
    # NIX_PATH = "nixpkgs=https://github.com/nixos/nixpkgs/archive/refs/heads/master.tar.gz";
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/secrets.key";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/share/cargo/bin"
    "${config.home.homeDirectory}/scripts/bin" # need this for my personal scripts
    # "${config.home.homeDirectory}/.local/bin" # need this for `uv tools`
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;

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
      "sb" = "python3 ~/scripts/bin/linux_util.py --source_bash_profile";
      "cdd" = "python3 ~/scripts/bin/linux_util.py --cd_with_eza";

      # Weather aliases
      "weather" = "python3 ~/scripts/bin/linux_util.py --weather";
      "weatherd" = "python3 ~/scripts/bin/linux_util.py --weather_detailed";
      "weatherc" = "python3 ~/scripts/bin/linux_util.py --weather_cities";

      # FZF Scripts
      "vv" = "python3 ~/scripts/bin/fzf_util.py --open_file";
      "fe" = "python3 ~/scripts/bin/fzf_util.py --empty_files";
      "fb" = "python3 ~/scripts/bin/fzf_util.py --big_files";
      "fs" = "python3 ~/scripts/bin/fzf_util.py --find_scripts";
      "fm" = "python3 ~/scripts/bin/fzf_util.py --move_file";
      "fc" = "python3 ~/scripts/bin/fzf_util.py --copy_file";
      "ff" = "python3 ~/scripts/bin/fzf_util.py --file_phrase";

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
      "l" =
        "eza --color=always --icons=always --long --all --group-directories-first --git --no-permissions --no-filesize --no-time --no-user";
      "ll" = "eza --color=always --icons=always --long --all --group-directories-first --git";
      "lls" =
        "eza --color=always --icons=always --long --all --group-directories-first --total-size --sort=size --reverse";
      "lll" = "eza --color=always --icons=always --long -all";

      # Trash
      "rmd" = "trash";
      "trl" = "trash list";
      "tra" = "trash empty --all";
      "trr" = "python3 ~/scripts/bin/fzf_util.py --restore_file";
      "tre" = "python3 ~/scripts/bin/fzf_util.py --empty_trash";

      # Git
      "ginit" = "python3 ~/scripts/bin/git_util.py --init_template";
      "gpu" = "git push";
      "gpl" = "git pull";
      "ga" = "git add";
      "gall" = "git add -A";
      "gc" = "git commit";
      "gcm" = "git commit -m";
      "gcw" = "python3 ~/scripts/bin/git_util.py --commit_workflow";
      "gl" = "git log";
      "glo" = "git log --oneline";
      "glg" = "python3 ~/scripts/bin/git_util.py --log_graph";
      "gpulla" = "python3 ~/scripts/bin/git_util.py --pull_all_dirs";
      "gpusha" = "python3 ~/scripts/bin/git_util.py --push_all_dirs";
      "gac" = "python3 ~/scripts/bin/git_util.py --auto_commit";
      "gcame" = "git commit --amend --no-edit";
      "gcheck" = "git checkout .";
      "gs" = "git status -sb";
      "gsa" = "python3 ~/scripts/bin/git_util.py --status_all_dirs";
      "gclean" = "python3 ~/scripts/bin/git_util.py --clean_up";
      "gd" = "git diff -w";
      "gh-create" = "python3 ~/scripts/bin/git_util.py --create_push_gh_repo";

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

      # Function to source files if they exist
      function source_if_exists {
        if test -r "$1"; then source "$1"; fi
      }

      # Source additional scripts, aliases, and exports
      source_if_exists $HOME/nixos-config/bin/linux_scripts.sh

      # Initialize external programs and utilities
      eval "$(starship init bash)"
      source_if_exists $HOME/.bash-preexec.sh
      eval "$(atuin init bash)"
      eval "$(uv generate-shell-completion bash)"
      eval "$(zoxide init bash)"

    '';
  };

}
