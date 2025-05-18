{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.programs.emacs;
  # myEmacs = pkgs.emacsWithPackagesFromUsePackage {
  myEmacs = (pkgs.emacsPackagesFor pkgs.emacs-git-pgtk).emacsWithPackages (
    epkgs:
      (with epkgs; [
        base16-theme
        dashboard
        consult
        diff-hl
        doom-modeline
        which-key
        tree-sitter
        dap-mode
        orderless
        nix-mode
        typst-ts-mode
        web-mode
        lsp-mode
        rustic
        nixfmt
        vertico
        marginalia
        flycheck
        corfu
        cape
        magit
        evil
        evil-collection
        evil-commentary
        evil-matchit
      ])
      ++ (with pkgs; [
        prettierd
        nixd
        vscode-langservers-extracted
        tinymist
      ])
  );
in {
  options.custom.programs.emacs = {enable = mkEnableOption "programs.emacs";};

  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = myEmacs;
      extraConfig = builtins.readFile ./init.el;
    };
  };

  # services.emacs = {
  #   enable = true;
  #   client.enable = true;
  #   defaultEditor = true;
  #   socketActivation.enable = true;
  #   startWithUserSession = true;
  # };
}
