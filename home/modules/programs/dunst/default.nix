{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.dunst;
in {
  options.custom.programs.dunst = {
    enable = mkEnableOption "programs.dunst";
  };

  config = mkIf cfg.enable {
    services = {
      dunst = {
        enable = mkDefault true;
        settings = {
          global = {
            width = mkDefault 300;
            height = mkDefault 300;
            offset = mkDefault "30x50";
            origin = mkDefault "top-right";
            transparency = mkDefault 10;
            frame_color = mkDefault "#1D1C19";
            font = mkDefault "AtkinsonHyperlegible";
          };

          urgency_normal = {
            background = mkDefault "#0d0c0c";
            foreground = mkDefault "#c5c9c5";
            timeout = mkDefault 10;
          };
        };
        iconTheme = {
          name = mkDefault "Papirus-Dark";
          package = mkDefault pkgs.papirus-icon-theme;
        };
      };
    };
  };
}
