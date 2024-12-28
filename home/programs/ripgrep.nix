{ pkgs, ... }: {

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--glob=!.git/*"
      "--glob=!*.pdf"
      "--glob=!*.parquet"
      "--glob=!*.{jpg,jpeg,png,gif,bmp,tiff}"
      "--smart-case"
      "--hidden" # search hidden files
      "--max-columns=150"
      # "--max-columns-preview=true"
      "--context=1" # show how many lines surrounding a match
    ];
  };
}


