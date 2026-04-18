{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.zsh;
  options = {
      custom.zsh = {
        enable = lib.mkEnableOption "Enable Zsh with user config";
      };
    };
in {
  inherit options;
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable =  true;
    };

    environment.systemPackages = [pkgs.customPackages.zsh];
  };
}
