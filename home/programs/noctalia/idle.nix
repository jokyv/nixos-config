{ config, pkgs, lib, ... }:

{
  programs.noctalia.settings = {
    idle = {
      behavior_order = [ "screen-off" "lock" "lock-and-suspend" ];
      pre_action_fade_seconds = 3.0;

      behavior = {
        "screen-off" = {
          action = "screen_off";
          timeout = 300;
          enabled = true;
          command = "";
          resume_command = "";
        };
        lock = {
          action = "lock";
          timeout = 360;
          enabled = true;
          command = "";
          resume_command = "";
        };
        "lock-and-suspend" = {
          action = "lock_and_suspend";
          timeout = 1800;
          enabled = true;
          command = "";
          resume_command = "";
        };
      };
    };
  };
}