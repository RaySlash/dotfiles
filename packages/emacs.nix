{
  config,
  wlib,
  lib,
  pkgs,
  ...
}: {
  imports = [wlib.wrapperModules.emacs];

  config.configFile = builtins.readFile ./configs/emacs-init.el;
  config.userDirectory = "~/.emacs.d";
  config.package = pkgs.emacs-pgtk;
  config.emacsPackages = epkgs:
    with epkgs; [
      pdf-tools
      nerd-icons
    ];
}
