{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault;
  cfg = config.custom.niri;
  options = {
    custom.niri = {
      enable = lib.mkEnableOption "Enable niri with user config";
    };
  };
in
{
  inherit options;
  config = lib.mkIf cfg.enable {
    programs = {
      nm-applet.enable = mkDefault true;
      dconf.enable = mkDefault true;
      niri = {
        enable = mkDefault true;
        package = mkDefault pkgs.customPackages.niri;
      };
    };

    environment.systemPackages = with pkgs; [
      customPackages.yazi
      customPackages.neovim
      customPackages.foot
      customPackages.swaylock
      customPackages.swayidle
      customPackages.waybar
      customPackages.fuzzel

      nerd-fonts.iosevka
      atkinson-hyperlegible
      apple-cursor
      papirus-icon-theme
    ];
  };
}
