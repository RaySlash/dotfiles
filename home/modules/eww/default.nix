{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.eww;
in {
  options.custom.programs.eww = {
    enable = mkEnableOption "programs.eww";
  };

  config = mkIf cfg.enable {
    programs = {
      eww = {
        enable = mkDefault true;
        configDir = mkDefault ./config;
      };
    };

    home = {
      packages = with pkgs; [
        inputs.meteorbom.packages.${pkgs.system}.default
        jq
        lm_sensors
        python3
        socat
      ];
    };
  };
}
