{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.emacs;
in {
  options.custom.emacs = {enable = mkEnableOption "emacs";};

  config = mkIf cfg.enable {
    services.emacs = {
      enable = true;
      install = true;
      startWithGraphical = true;
      package = pkgs.emacs-pgtk;
    };
  };
}
