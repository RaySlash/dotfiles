{ inputs
  , nixpkgs ? inputs.nixpkgs
  , utils ? import ./lib.nix {inherit inputs;}
}: utils.forEachSystem (system: let
  # Currently emacats requires `inputs.nixpkgs` and `inputs.emacs-overlay`
  # to import packages and utility functions.
  pkgs = import nixpkgs {inherit system;};
  elib = inputs.emacs-overlay.lib.${system};
  defaultPackageName = "emacats";

  # These are runtime dependencies which include things like LSPs, Linters,
  # Formatters, Compilers etc.
  EmacsRuntimeDeps = with pkgs; [
    prettierd
    nixd
    vscode-langservers-extracted
    typst
    tinymist
  ];

mkTreeSitterGrammers = epkgs: with epkgs; [
    tree-sitter
    (treesit-grammars.with-grammars (g: with g; [
      tree-sitter-bash tree-sitter-c tree-sitter-c-sharp tree-sitter-clojure tree-sitter-cmake tree-sitter-comment tree-sitter-commonlisp tree-sitter-cpp tree-sitter-css tree-sitter-dockerfile tree-sitter-elisp tree-sitter-elm tree-sitter-fennel tree-sitter-haskell tree-sitter-html tree-sitter-http tree-sitter-hyprlang tree-sitter-java tree-sitter-javascript tree-sitter-jsdoc tree-sitter-json tree-sitter-json5 tree-sitter-kotlin tree-sitter-lua tree-sitter-make tree-sitter-markdown tree-sitter-markdown-inline tree-sitter-nix tree-sitter-python tree-sitter-query tree-sitter-regex tree-sitter-rust tree-sitter-scheme tree-sitter-scss tree-sitter-sql tree-sitter-toml tree-sitter-tsx tree-sitter-typescript tree-sitter-typst tree-sitter-vim tree-sitter-yaml tree-sitter-zig
    ]))
  ];
  initFile = builtins.readFile ./init.el;
  findPackagesFromUsePackage = ''
    awk '/use-package /{print $2}'
  '';
  # Parse and add all packages defined with `use-package` inside init file.
  # https://github.com/nix-community/emacs-overlay/blob/master/README.org#extra-library-functionality
  defaultPackage = elib.emacsWithPackagesFromUsePackage {
    config = ./init.el;
    defaultInitFile = true;
    alwaysEnsure = true;
    package = pkgs.emacs-pgtk;
    extraEmacsPackages = epkgs:
      (mkTreeSitterGrammers epkgs)
      ++ EmacsRuntimeDeps;
  };
  # nixosModule = utils.mkNixosModules {
  #   moduleNamespace = [defaultPackageName];
  #   inherit nixpkgs defaultPackageName;
  # };
  # homeModule = utils.mkHomeModules {
  #   moduleNamespace = [defaultPackageName];
  #   inherit nixpkgs defaultPackageName;
  # };
in {
  packages.emacats = defaultPackage;
  # nixosModules.default = nixosModule;
  # homeModules.default = homeModule;
})
