{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.niri ];

  config.extraPackages = with pkgs; [
    xwayland-satellite
    awww
    easyeffects
    cliphist
    wl-clipboard
    wlogout
    wireplumber
    pavucontrol
    brightnessctl
  ];
  config."config.kdl".content = builtins.readFile ./configs/niri.kdl;
}
