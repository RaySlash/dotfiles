{
  inputs,
  nixpkgs ? inputs.nixpkgs,
  utils ? import ./lib.nix {inherit inputs;},
}:
utils.forEachSystem (system: let
  # Currently emacats requires `inputs.nixpkgs`
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  # These are runtime dependencies which include things like LSPs, Linters,
  # Formatters, Compilers etc.
  EmacsRuntimeDeps = with pkgs; [
    # Lsp
    bash-language-server
    lua-language-server
    nixd
    marksman
    vscode-langservers-extracted
    typst
    tinymist
    taplo-lsp
    cmake-language-server
    yaml-language-server
    # Formatters
    clang-tools
    prettierd
    taplo
    sql-formatter
    stylua
    shfmt
    alejandra
    tidyp
    typstyle
    gawk
    # Utils
    coreutils-full
    ripgrep
    fd
    cmake
  ];

  # initFile = builtins.readFile ./init.el;
  # findPackagesFromUsePackage = ''
  #   awk '/use-package /{print $2}'
  # '';

  # Parse and add all packages defined with `use-package` inside init file.
  # https://github.com/nix-community/emacs-overlay/blob/master/README.org#extra-library-functionality
  defaultPackage = (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (epkgs: EmacsRuntimeDeps);
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
