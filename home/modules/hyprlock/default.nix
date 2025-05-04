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
            disable_loading_bar = mkDefault true;
            grace = mkDefault 300;
            hide_cursor = mkDefault true;
            no_fade_in = mkDefault false;
          };

          background = mkDefault [
            {
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = mkDefault [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              placeholder_text = "Password...";
              shadow_passes = 2;
            }
          ];
        };
      };
    };
  };
}
