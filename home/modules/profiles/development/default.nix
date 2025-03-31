{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.profiles.development;
in {
  options.custom.profiles.development = {enable = mkEnableOption "profiles.development";};

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
