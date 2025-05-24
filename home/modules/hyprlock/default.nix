{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.hyprlock;
in {
  options.custom.programs.hyprlock = {
    enable = mkEnableOption "programs.hyprlock";
  };

  config = mkIf cfg.enable {
    programs = {
      hyprlock = {
        enable = mkDefault true;
        settings = mkDefault {
          general = {
            disable_loading_bar = true;
            grace = 300;
	    ignore_empty_input = true;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              blur_passes = 3;
              blur_size = 8;
            }
          ];

	  label = [
	    {
	      monitor = "";
	      text = "cmd[update:100000] echo $(date '+%a, %d %b %Y')";
              position = "50%, 20%";
	      font_size = 24;
	    }
	    {
	      monitor = "";
	      text = "cmd[update:1000] echo $(date '+%I:%M %p')";
              position = "50%, 20%";
	      font_size = 48;
	    }
	  ];

          input-field = [
            {
              monitor = "";
              size = "200, 50";
              position = "50%, 50%";
	      halign = "center";
	      valign = "center";
              dots_center = true;
              fade_on_empty = false;
	      hide_input = false;
              placeholder_text = "Enter Password...";
              shadow_passes = 2;
            }
          ];
        };
      };
    };
  };
}
