{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.programs.emacs;
in {
  options.custom.programs.emacs = {enable = mkEnableOption "programs.emacs";};

  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-git-pgtk;
    };

    services.emacs = {
      enable = true;
      client.enable = true;
      defaultEditor = true;
      package = pkgs.emacs-git-pgtk;
      socketActivation.enable = true;
      startWithUserSession = true;
    };
  };
}
