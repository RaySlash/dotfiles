{
  config,
  wlib,
  lib,
  pkgs,
  ...
}: {
  imports = [wlib.wrapperModules.yazi];

  config.package = pkgs.yazi;
  config.settings.theme.flavor = {
    light = "kanagawadragon";
    dark = "kanagawadragon";
  };
  config.flavors = {
    kanagawadragon = ./configs/yazi/kanagawadragon.yazi;
  };
}
