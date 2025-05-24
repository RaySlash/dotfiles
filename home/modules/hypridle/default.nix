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
      hyprsunset = {
	enable = mkDefault true;
	transitions = mkDefault {
	  sunrise = {
	    calendar = "*-*-* 06:00:00";
	    requests = [
	      [ "temperature" "6500" ]
	      [ "gamma 100" ]
	    ];
	  };
	  sunset = {
	    calendar = "*-*-* 19:00:00";
	    requests = [
	      [ "temperature" "5000" ]
	      [ "gamma 80" ]
	    ];
	  };
	};
      };
      hypridle = {
        enable = mkDefault true;
        settings = {
          general = {
            after_sleep_cmd = mkDefault "hyprctl dispatch dpms on";
            lock_cmd = mkDefault "hyprlock";
          };

          listener = [
            {
              timeout = 600;
              on-timeout = "hyprctl hyprsunset gamma 50";
              on-resume = "hyprctl hyprsunset gamma 100";
            }
            {
              timeout = 800;
              on-timeout = "hyprctl hyprsunset gamma 30";
              on-resume = "hyprctl hyprsunset gamma 100";
            }
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
