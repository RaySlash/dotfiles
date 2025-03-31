{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.fuzzel;
in {
  options.custom.programs.fuzzel = {
    enable = mkEnableOption "programs.fuzzel";
  };

  config = mkIf cfg.enable {
    programs = {
      fuzzel = {
        enable = mkDefault true;
        settings = {
          main = {
            font = mkDefault "AtkinsonHyperlegible:size=14";
            dpi-aware = mkDefault false;
            use-bold = mkDefault true;
            icons-enabled = mkDefault true;
            icon-theme = mkDefault "Papirus-Dark";
            terminal = mkDefault "kitty -1";
            x-margin = mkDefault 20;
            y-margin = mkDefault 20;
            horizontal-pad = mkDefault 30;
            vertical-pad = mkDefault 20;
            tabs = mkDefault 4;
            inner-pad = mkDefault 50;
            line-height = mkDefault 30;
          };
          colors = {
            background = mkDefault "000000ee";
            text = mkDefault "f9f5d7ff";
            match = mkDefault "563A9Cff";
            selection = mkDefault "433D8Bff";
            selection-text = mkDefault "FFE1FFff";
            selection-match = mkDefault "8B5DFFff";
            border = mkDefault "FFE1FFee";
          };
          border = {
            width = mkDefault 2;
            radius = mkDefault 15;
          };
        };
      };
    };
  };
}
