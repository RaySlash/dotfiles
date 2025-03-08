{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.yazi;
in {
  options.custom.yazi = {enable = mkEnableOption "yazi";};

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      flavors = {
        "kanagawa-dragon.yazi" = inputs.kanagawa-yazi;
      };
      settings = {
        theme = lib.importTOML ./theme.toml;
      };
    };
  };
}
