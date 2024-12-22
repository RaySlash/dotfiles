{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.emacs-addons;
in {
  options.custom.emacs-addons = {enable = mkEnableOption "emacs-addons";};

  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      # extraPackages = with pkgs.emacsPackages; [
      #   leaf
      # ];
    };

    services.emacs = {
      enable = true;
      client.enable = true;
      defaultEditor = true;
      package = pkgs.emacs-pgtk;
      socketActivation.enable = true;
      startWithUserSession = true;
    };
  };
}
