{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.yazi;
in {
  options.custom.programs.yazi = {enable = mkEnableOption "programs.yazi";};

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
