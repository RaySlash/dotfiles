{
  config,
  wlib,
  lib,
  pkgs,
  ...
}: {
  imports = [wlib.wrapperModules.fuzzel];

  config.package = pkgs.fuzzel;
  config.settings = {
    main = {
      use-bold = "yes";
      icon-theme = "Papirus-Dark";
      icons-enabled = "yes";
      show-actions = "yes";
      x-margin = 20;
      y-margin = 20;
      width = 50;
      tabs = 4;
      horizontal-pad = 30;
      vertical-pad = 20;
      inner-pad = 50;
      line-height = 30;
    };
    border = {
      width = 2;
      radius = 15;
    };
    colors = {
      background = "000000ee";
      text = "f9f5d7ff";
      match = "563A9Cff";
      selection = "433D8Bff";
      selection-text = "FFE1FFff";
      selection-match = "8B5DFFff";
      border = "FFE1FFee";
    };
  };
}
