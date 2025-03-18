{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.themes;
in {
  options.custom.themes = {enable = mkEnableOption "themes";};

  config = mkIf cfg.enable {
    console = {
      font = mkDefault "Lat2-Terminus16";
      keyMap = mkDefault "us";
    };
    fonts = {
      fontDir.enable = mkDefault true;
      packages = with pkgs; [
        nerd-fonts.iosevka-term
        atkinson-hyperlegible
        jetbrains-mono
      ];
    };
  };
}
