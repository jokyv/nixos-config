{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      # Global prompt configuration
      format = ''
        $username$hostname$directory$sudo$git_branch$git_commit$git_state$git_status$git_metrics$gcloud$fill$jobs$python$rust$cmd_duration$time$line_break$status$character
      '';

      # Timeouts and general settings
      command_timeout = 750;
      scan_timeout = 50;
      add_newline = true;

      # Module configurations
      fill = {
        disabled = false;
        symbol = ".";
        style = "bold #859289"; # Gray
      };

      character = {
        disabled = false;
        format = "$symbol ";
        success_symbol = "[❯](bold purple)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold green)";
      };

      cmd_duration = {
        disabled = false;
        min_time = 2000; # show duration if takes more than 2 seconds
        format = "\\[[tt: $duration]($style)\\]";
        show_milliseconds = true;
        show_notifications = false;
        min_time_to_notify = 5000;
      };

      directory = {
        disabled = false;
        truncation_length = 3;
        truncate_to_repo = true;
        truncation_symbol = "../";
        fish_style_pwd_dir_length = 0;
        use_logical_path = true;
        read_only = " 🔒";
        read_only_style = "fg:red";
      };

      shell = {
        disabled = false;
        format = "running in [$indicator]($style) shell";
        bash_indicator = "Bash ";
        nu_indicator = "Nushell";
        style = "bold blue";
      };

      gcloud = {
        disabled = false;
        format = "(\\[$symbol\\]($style)) ";
        symbol = " ";
      };

      git_branch = {
        disabled = false;
        style = "bright-black ";
        format = "(\\[$symbol$branch\\]($style)) ";
        symbol = " ";
        truncation_symbol = "…";
        ignore_branches = [ "main" "master" ];
      };

      git_commit = {
        disabled = false;
        style = "bright-black";
        tag_symbol = " 🏷 ";
        format = "\\[$hash$tag\\]($style) ";
        commit_hash_length = 7;
        only_detached = true;
      };

      git_state = {
        disabled = false;
        rebase = "REBASING";
        merge = "MERGING";
        revert = "REVERTING";
        cherry_pick = "CHERRY-PICKING";
        bisect = "BISECTING";
        am = "AM";
        am_or_rebase = "AM/REBASE";
        format = "\\[[$state]($style)\\]";
      };

      git_status = {
        disabled = false;
        format = "(\\[$all_status$ahead_behind\\]($style)) ";
        stashed = " ";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        conflicted = "=";
        deleted = "✘";
        renamed = "»";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      git_metrics = {
        disabled = false;
        format = "([+$added]($added_style) )([-$deleted]($deleted_style))";
      };

      hostname = {
        disabled = false;
        ssh_only = true;
        trim_at = ".";
        format = "\\[[$symbol($hostname)]($style)\\]";
      };

      jobs = {
        disabled = true;
        symbol = "+ ";
        symbol_threshold = 1;
        number_threshold = 2;
        format = "[[($symbol)($number)]($style)]";
      };

      line_break = {
        disabled = false;
      };

      python = {
        disabled = false;
        python_binary = "python3";
        style = "blue bold";
        symbol = " ";
        format = "\\[[$symbol($version) ($virtualenv)]($style)\\]";
      };

      nix_shell = {
        disabled = false;
        impure_msg = "[impure shell](bold red)";
        pure_msg = "[pure shell](bold green)";
        unknown_msg = "[unknown shell](bold yellow)";
        format = "via [☃️ $state( \\($name\\))](bold blue) ";
      };

      rust = {
        disabled = false;
        style = "red bold";
        format = "\\[[$symbol($version)]($style)\\]";
        symbol = " ";
      };

      status = {
        disabled = false;
        # format = "\\[[$symbol$common_meaning$signal_name$maybe_int]\\]($style) ";
        symbol = "✖ ";
      };

      sudo = {
        disabled = false;
        format = "\\[[$symbol($version)]($style)\\]";
        symbol = "";
      };

      time = {
        disabled = false;
        format = "\\[[$time]($style)\\]";
        utc_time_offset = "local";
        time_range = "-";
      };

      username = {
        disabled = false;
        format = "\\[[$user]($style)\\]";
        style_root = "bold bg:#555555 fg:red";
        style_user = "bold bg:#555555 fg:yellow";
        show_always = false;
      };
    };
  };
}
