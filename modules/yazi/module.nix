{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.yazi;
in {
  options.custom.yazi = {enable = mkEnableOption "yazi";};

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = mkDefault true;
      flavors = mkDefault {
        "kanagawa-dragon.yazi" = inputs.kanagawa-yazi;
      };
      settings = {
        theme = mkDefault (lib.importTOML ./theme.toml);
      };
    };
  };
}
