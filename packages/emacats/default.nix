{ inputs
  , nixpkgs ? inputs.nixpkgs
  , utils ? import ./lib.nix {inherit inputs;}
}: utils.forEachSystem (system: let
  # Currently emacats requires `inputs.nixpkgs` `inputs.nixcats` and `inputs.emacs-overlay`
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

  tsGrammers = [
    "bash" "c" "c-sharp" "clojure" "cmake" "comment" "commonlisp" "cpp" "css" "dockerfile" "elisp" "elm" "fennel" "haskell" "html" "http" "hyprlang" "java" "javascript" "jsdoc" "json" "json5" "kotlin" "lua" "make" "markdown" "markdown-inline" "nix" "python" "query" "regex" "rust" "scheme" "scss" "sql" "toml" "tsx" "typescript" "typst" "vim" "yaml" "zig"
  ];
  # Parse and add all packages defined with `use-package` inside init file.
  # https://github.com/nix-community/emacs-overlay/blob/master/README.org#extra-library-functionality
  defaultPackage = elib.emacsWithPackagesFromUsePackage {
    config = ./init.el;
    defaultInitFile = true;
    alwaysEnsure = true;
    package = pkgs.emacs-pgtk;
    extraEmacsPackages = epkgs:
      (utils.mkTreeSitterGrammers epkgs tsGrammers)
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
