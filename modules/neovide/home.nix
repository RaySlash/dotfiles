{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.neovide;
in {
  options.custom.neovide = {enable = mkEnableOption "neovide";};

  config = mkIf cfg.enable {
    programs.neovide = {
      enable = true;
      package = pkgs.unstable.neovide;
      settings = {
        srgb = true;
        tabs = true;
        theme = "auto";
        title-hidden = true;
        vsync = true;
        wsl = false;

        font = {
          normal = ["IosevkaTerm Nerd Font"];
          size = 14.0;
          edging = "antialias";
          hinting = "full";
        };
      };
    };
  };
}
