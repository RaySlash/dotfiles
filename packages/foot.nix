{
  config,
  wlib,
  lib,
  pkgs,
  ...
}: {
  imports = [wlib.wrapperModules.foot];

  config.package = pkgs.foot;
  config.settings = {
    main = {
      font = "IosevkaNerdFont-Regular:size=14";
      font-bold = "IosevkaNerdFont-Bold:size=14";
      font-italic = "IosevkaNerdFont-Italic:size=14";
      font-bold-italic = "IosevkaNerdFont-BoldItalic:size=14";
    };
    bell.system = "no";
    cursor.blink = "yes";
    mouse.hide-when-typing = "yes";
    colors-dark = {
      background = "000000";
      alpha = "0.8";
      foreground = "c5c9c5";
      regular0 = "1d1c19";
      regular1 = "c4746e";
      regular2 = "87a987";
      regular3 = "c4b28a";
      regular4 = "8ba4b0";
      regular5 = "8992a7";
      regular6 = "8ea4a2";
      regular7 = "7a8382";
      bright0 = "282727";
      bright1 = "c4746e";
      bright2 = "87a987";
      bright3 = "c4b28a";
      bright4 = "8ba4b0";
      bright5 = "8992a7";
      bright6 = "8ea4a2";
      bright7 = "c5c9c5";
    };
  };
}
