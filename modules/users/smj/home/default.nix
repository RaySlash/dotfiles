{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.users.smj;
in {
  options.custom.users.smj = {enable = mkEnableOption "users.smj";};

  config = mkIf cfg.enable {
    home = {
      username = "smj";
      homeDirectory = "/home/smj";
    };

    programs.git = {
      userEmail = mkDefault "45141270+RaySlash@users.noreply.github.com";
      userName = mkDefault "RaySlash";
    };
  };
}
