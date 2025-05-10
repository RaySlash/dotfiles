{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.programs.emacs;
  myEmacs = with pkgs; ((emacsPackagesFor emacs-git-pgtk).emacsWithPackages
    (epkgs: (with epkgs; [
      lsp-mode
      lsp-ui
      lsp-ivy
      lsp-treemacs
      consult
      which-key
      tree-sitter
      dap-mode
      orderless
      nix-mode
      nixfmt
      vertico
      marginalia
      base16-theme
      flycheck
      evil
      ivy
    ]) ++ (with pkgs; [
      alejandra
      clang-tools
      prettierd
      rust-analyzer
      ccls
      nixd
      vscode-langservers-extracted
      tinymist
    ])));
in {
  options.custom.programs.emacs = {enable = mkEnableOption "programs.emacs";};

  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = myEmacs;
      extraConfig = builtins.readFile ./init.el;
      # extraPackages = epkgs: (with epkgs; [
      #   lsp-mode
      #   tree-sitter
      #   dap-mode
      #   orderless
      #   nix-mode
      #   nixfmt
      #   vertico
      #   marginalia
      #   base16-theme
      #   flycheck
      #   evil
      #   ivy
      # ]);
    };

    services.emacs = {
      enable = true;
      client.enable = true;
      defaultEditor = true;
      socketActivation.enable = true;
      startWithUserSession = true;
    };
  };
}
