{
  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        ratio = [ 2 4 3 ];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_symlink = true;
        show_hidden = true;
        scrolloff = 5;
        title_format = "Yazi: {cwd}";
      };
      preview = {
        wrap = "no";
        max_width = 1200;
        max_height = 900;
      };
    };
  };
}
