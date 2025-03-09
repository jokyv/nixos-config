{ config, pkgs, lib, ... }:

{
  programs.nushell = {
    enable = true;
    configFile = {
      text = ''

        # Core configuration
        $env.config = {
            show_banner: false    
            table: {
                mode: rounded    
                index_mode: always
                show_empty: true
                padding: { left: 1, right: 1 }
                trim: {
                    methodology: wrapping
                    wrapping_try_keep_words: true
                }
            }
            error_style: "fancy"
            completions: {
                case_sensitive: false
                quick: true
                partial: true
                algorithm: "prefix"
            }
            history: {
                max_size: 100_000
                sync_on_enter: true
                file_format: "sqlite"
                isolation: false
            }
            filesize: {
                unit: "MB"
            }
            footer_mode: 25
            float_precision: 2
            use_ansi_coloring: true
            edit_mode: vi
        }

        # Environment variables
        $env.EDITOR = "hx"
        $env.PATH = (
            $env.PATH 
            | split row (char esep) 
            | append [
                "~/scripts/bin"
                "~/scripts/apps"
                "~/.local/share/uv/tools/aider-chat/bin/"
            ]
        )

        let exclude_list = ['target' 'inode' 'readonly' 'num_link' 'accessed']

        def l [] { ls . | sort-by type size }
        def ll [] {
            ls -al 
            | where { |it| not ($exclude_list | any { |exclude| $it.name | str contains $exclude }) } 
            | sort-by type
        }
        def lls [] {
            ls -al 
            | where { |it| not ($exclude_list | any { |exclude| $it.name | str contains $exclude }) } 
            | sort-by size
        }



        # Keybindings
        $env.config.keybindings = [
            {
                name: completion_menu
                modifier: none
                keycode: tab
                mode: [emacs vi_normal vi_insert]
                event: {
                    until: [
                        { send: menu name: completion_menu }
                        { send: menunext }
                    ]
                }
            }
        ]
      '';
    };

    environmentVariables = {
      # SOPS
      SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/secrets.key";


    };

    shellAliases = {

      # Easier Navigation
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      "c" = "clear";
      "ssd" = "sudo shutdown now";
      "sr" = "sudo reboot";

      # File Management
      "mkdir" = "mkdir -v";
      "rm" = "rm -iv";
      "mv" = "mv -iv";
      "cp" = "cp -iv";
      "ln" = "ln -i";

      # Utility Aliases
      "cat" = "bat --paging=never";
      "b" = "bash";
      "e" = "exit";

      # LS Aliases
      # "l" = "{ ls . | sort-by type size }";
      # "ll" = "ls -al | where { |it| not ($exclude_list | any { |exclude| $it.name | str contains $exclude }) } | sort-by type";
      # "lls" = "ls -al | where { |it| not ($exclude_list | any { |exclude| $it.name | str contains $exclude }) } | sort-by size";

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
      "a" = "bash -c \". ~/uv_default/bin/activate && nu\"";
      "talk" = "bash -c \". ~/talk_to_ai/bin/activate && nu\"";
      "d" = "deactivate";

      # Trashy
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
    };
  };
}




























