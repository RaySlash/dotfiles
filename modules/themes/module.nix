{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.themes;
in {
  options.custom.themes = {enable = mkEnableOption "themes";};

  config = mkIf cfg.enable {
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        nerd-fonts.iosevka-term
        atkinson-hyperlegible
        jetbrains-mono
      ];
    };
  };
}
