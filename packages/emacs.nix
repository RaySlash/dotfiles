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
  config.extraPackages = with pkgs; [
    # Formatters
    elmPackages.elm-format
    sql-formatter
    alejandra
    stylua
    shfmt
    tidyp
    # LSPs
    ccls
    nil
    nixd
    pyright
    bash-language-server
    lua-language-server
    taplo
    typstyle
    gawk
    marksman
    prettierd
    vscode-langservers-extracted
    tinymist
    cmake-language-server
    yaml-language-server
    haskell-language-server
    elmPackages.elm-language-server
    #Tools
    clang-tools
    typst
    coreutils-full
    ripgrep
    fzf
    fd
  ];
  config.emacsPackages = epkgs:
    with epkgs; [
      pdf-tools
      nerd-icons
    ];
}
