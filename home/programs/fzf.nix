{ config, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true; # If you use bash
    # enableZshIntegration = true; # If you use zsh

    defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    defaultOptions = [
      "--bind 'ctrl-/:toggle-preview'"
      # "--bind 'ctrl-y:execute-silent(echo -n {2..} | ${wl-copy})+abort'"
      "--bind=shift-tab:up"
      "--bind=tab:down"
      "--border"
      "--border-label="
      "--border=rounded"
      # "--color=border:#262626,label:#aeaeae,query:#d9d9d9"
      "--color header:italic"
      "--color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf"
      # "--header 'Press CTRL-Y to copy to clipboard'"
      "--height 45%"
      "--info=inline"
      "--layout=reverse"
      "--margin=1"
      "--marker=>"
      "--padding=1"
      "--pointer=◆"
      "--preview 'echo {}'"
      "--preview-window=border-rounded"
      "--preview-window up:3:hidden:wrap"
      "--prompt=> "
      "--reverse"
      "--scrollbar=│"
      "--separator=─"
      "--sort"
    ];


    # FZF environment variables
    fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    changeDirWidgetCommand = "fd --type=d --hidden --strip-cwd-prefix --exclude .git . $HOME";
  };
}
