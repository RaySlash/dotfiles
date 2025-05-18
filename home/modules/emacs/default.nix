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
  EmacsModes = epkgs: (with epkgs; [
    base16-theme
    dashboard
    consult
    diff-hl
    doom-modeline
    which-key
    dap-mode
    orderless
    nix-ts-mode
    typst-ts-mode
    web-mode
    zig-mode
    lsp-mode
    rustic
    nixfmt
    smartparens
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
    tree-sitter
    tree-sitter-langs
  ]);

  EmacsRuntimeDeps = (with pkgs; [
    prettierd
    nixd
    vscode-langservers-extracted
    tinymist
  ]);

  EmacsTreeSitterGrammers = epkgs: [
    (epkgs.treesit-grammars.with-grammars (g: with g; [
      tree-sitter-bash tree-sitter-c tree-sitter-c-sharp tree-sitter-clojure tree-sitter-cmake tree-sitter-comment tree-sitter-commonlisp tree-sitter-cpp tree-sitter-css tree-sitter-dockerfile tree-sitter-elisp tree-sitter-elm tree-sitter-fennel tree-sitter-haskell tree-sitter-html tree-sitter-http tree-sitter-hyprlang tree-sitter-java tree-sitter-javascript tree-sitter-jsdoc tree-sitter-json tree-sitter-json5 tree-sitter-kotlin tree-sitter-lua tree-sitter-make tree-sitter-markdown tree-sitter-markdown-inline tree-sitter-nix tree-sitter-python tree-sitter-query tree-sitter-regex tree-sitter-rust tree-sitter-scheme tree-sitter-scss tree-sitter-sql tree-sitter-toml tree-sitter-tsx tree-sitter-typescript tree-sitter-typst tree-sitter-vim tree-sitter-yaml tree-sitter-zig
    ]))
  ];

  myEmacs = (with pkgs; (emacsPackagesFor emacs-git-pgtk)).emacsWithPackages
    (epkgs:
      (EmacsModes epkgs)
      ++ (EmacsTreeSitterGrammers epkgs)
      ++ EmacsRuntimeDeps);
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
