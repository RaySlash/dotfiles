{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.nix-addons;
in {
  options.custom.nix-addons = {enable = mkEnableOption "nix-addons";};

  config = mkIf cfg.enable {
    programs = {
      nix-index = {
        enable = mkDefault true;
        enableZshIntegration = mkDefault true;
      };
      direnv = {
        enable = mkDefault true;
        nix-direnv.enable = mkDefault true;
        enableZshIntegration = mkDefault true;
      };
    };
  };
}
