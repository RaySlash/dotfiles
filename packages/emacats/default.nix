{inputs}: let
  # Currently emacats requires `inputs.nixpkgs` and `inputs.emacs-overlay`
  # to import packages and utility functions respectively.
  inherit (builtins) foldl' attrNames elem;
  lib = inputs.nixpkgs.lib;

  /* From github:birdee/nixCats-nvim */
  eachSystem = systems: f: let
    # get function result and insert system variable
    op = attrs: system: let
      ret = f system;
      op = attrs: key: attrs // {
        ${key} = (attrs.${key} or { })
          // { ${system} = ret.${key}; };
      };
    in foldl' op attrs (attrNames ret);
  # Merge together the outputs for all systems.
  in foldl' op { } (systems ++
    (if builtins ? currentSystem && ! elem builtins.currentSystem systems
    # add the current system if --impure is used
    then [ builtins.currentSystem ]
    else []));

  # Make the derivation buildable by all available platforms in nixpkgs
  forEachSystem = eachSystem lib.platforms.all;


  # Function that gives a list of treesitter grammers
  # Use this instead of `epkgs.treesit-grammers.with-all-grammers`
  mkTreeSitterGrammers = epkgs: with epkgs; [
    tree-sitter
    (treesit-grammars.with-grammars (g: with g; [
      tree-sitter-bash tree-sitter-c tree-sitter-c-sharp tree-sitter-clojure tree-sitter-cmake tree-sitter-comment tree-sitter-commonlisp tree-sitter-cpp tree-sitter-css tree-sitter-dockerfile tree-sitter-elisp tree-sitter-elm tree-sitter-fennel tree-sitter-haskell tree-sitter-html tree-sitter-http tree-sitter-hyprlang tree-sitter-java tree-sitter-javascript tree-sitter-jsdoc tree-sitter-json tree-sitter-json5 tree-sitter-kotlin tree-sitter-lua tree-sitter-make tree-sitter-markdown tree-sitter-markdown-inline tree-sitter-nix tree-sitter-python tree-sitter-query tree-sitter-regex tree-sitter-rust tree-sitter-scheme tree-sitter-scss tree-sitter-sql tree-sitter-toml tree-sitter-tsx tree-sitter-typescript tree-sitter-typst tree-sitter-vim tree-sitter-yaml tree-sitter-zig
    ]))
  ];

in forEachSystem (system: let
  pkgs = import inputs.nixpkgs {inherit system;};
  elib = inputs.emacs-overlay.lib.${system};

  # These are runtime dependencies which include things like LSPs, Linters,
  # Formatters, Compilers etc.
  EmacsRuntimeDeps = (with pkgs; [
    prettierd
    nixd
    vscode-langservers-extracted
    typst
    tinymist
  ]);

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
in {
  packages.emacats = defaultPackage;
})
