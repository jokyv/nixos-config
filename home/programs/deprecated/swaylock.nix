{ pkgs, ... }:
{

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      effect-blur = "10x2";
      fade-in = 0.1;
      # font-size = 15;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-thickness = 7;
      indicator-radius = 300;
      indicator-idle-visible = true;
      # indicator-x-position = 1600;
      # indicator-y-position = 1000;
      # indicator
      clock = true;
      # timestr = "%I:%M %p";
      datestr = "%A, %d %B";
    };
  };
}
