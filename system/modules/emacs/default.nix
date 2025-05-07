{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.programs.emacs;
in {
  options.custom.programs.emacs = {enable = mkEnableOption "programs.emacs";};

  config = mkIf cfg.enable {
    services.emacs = {
      enable = true;
      install = true;
      startWithGraphical = true;
      package = pkgs.emacs-git-pgtk;
    };
  };
}
