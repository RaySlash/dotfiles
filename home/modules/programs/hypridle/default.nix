{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.hypridle;
in {
  options.custom.programs.hypridle = {
    enable = mkEnableOption "programs.hypridle";
  };

  config = mkIf cfg.enable {
    services = {
      hypridle = {
        enable = mkDefault true;
        settings = {
          general = {
            after_sleep_cmd = mkDefault "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = mkDefault false;
            lock_cmd = mkDefault "hyprlock";
          };

          listener = mkDefault [
            {
              timeout = 900;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
  };
}
