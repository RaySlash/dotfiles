{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.waybar ];

  config.configFile.content = builtins.readFile ./configs/waybar.json;
  config."style.css".content = builtins.readFile ./configs/waybar.css;
}
