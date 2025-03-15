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
    users.users = {
      smj = {
        isNormalUser = mkDefault true;
        extraGroups = mkDefault ["wheel" "podman" "docker" "audio" "video" "networkmanager"];
        shell = pkgs.zsh;
      };
    };
  };
}
